<?php
	// ==================================================================
	//  Author: Justin Vincent (justin@visunet.ie)
	//	Web: 	http://php.justinvincent.com
	//	Name: 	ezSQL
	// 	Desc: 	Class to make it very easy to deal with Oracle8 database connections.
	//
	// !! IMPORTANT !!
	//
	//  Please send me a mail telling me what you think of ezSQL
	//  and what your using it for!! Cheers. [ justin@visunet.ie ]
	//
	// ==================================================================
	// User Settings -- CHANGE HERE

	define("EZSQL_DB_USER", "");		// <-- oracle db user
	define("EZSQL_DB_PASSWORD", "");	// <-- oracle db password
	define("EZSQL_DB_NAME", "");		// <-- oracle db name

	// ==================================================================
	//	ezSQL Constants
	define("EZSQL_VERSION","1.26");
	define("OBJECT","OBJECT",true);
	define("ARRAY_A","ARRAY_A",true);
	define("ARRAY_N","ARRAY_N",true);

	// ==================================================================
	//	The Main Class

	class ezsql
	{
		var $trace = false;      // same as $debug_all
		var $debug_all = false;  // same as $trace
		var $show_errors = false;
		var $num_queries = 0;
		var $last_query;
		var $col_info;
		var $debug_called;
		var $vardump_called;

		// ==================================================================
		//	DB Constructor - connects to the server and selects a database

		function db($dbuser, $dbpassword, $dbname, $dbhost = '', $dbport = '')
		{
                        $dbport = $dbport ? ':' . $dbport : '';
                        $dbname =  $dbhost ? "//$dbhost$dbport/$dbname" : $dbname;
			$this->dbh = @OCILogon($dbuser, $dbpassword, $dbname);

			if ( ! $this->dbh )
			{
				$this->print_error("Error","<ol><b>Error establishing a database connection!</b><li>Are you sure you have the correct user/password?<li>Are you sure that you have typed the correct database instance name?<li>Are you sure that the database server is running?</ol>");
			}
			else
			{
				// Remember these values for the select function
				$this->dbuser = $dbuser;
				$this->dbpassword = $dbpassword;
				$this->dbname = $dbname;
			}       
		}

		// ==================================================================
		//	Select a DB instance (if another one needs to be selected)

		function select($db)
		{
			$this->db($this->dbuser, $this->dbpassword, $dbname);
		}

		// ====================================================================
		//	Format a string correctly for safe insert under all PHP conditions
		
		function escape($str)
		{
			return str_replace("'","''",str_replace("''","'",stripslashes($str)));		
		}

		// ==================================================================
		//	Print SQL/DB error.

		function print_error($title = "SQL/DB Error", $str = "")
		{
			
			// All erros go to the global error array $EZSQL_ERROR..
			global $EZSQL_ERROR;
						
			// If no error string then assume an oracle error is required
			if ( !$str )
			{
				$error = OCIError();
				$str = $error["message"] . "-" . $error["code"];
			}

			// Log this error to the global array..
			$EZSQL_ERROR[] = array 
							(
								"query" => $this->last_query,
								"error_str"  => $str
							);

			// Is error output turned on or not..
			if ( $this->show_errors )
			{
				// If there is an error then take note of it
				print "<blockquote><font face=arial size=2 color=ff0000>";
				print "<b>$title --</b> ";
				print "[<font color=000077>$str</font>]";
				print "</font></blockquote>";
			}
			else
			{
				return false;	
			}
		}

		// ==================================================================
		//	These special Oracle functions make sure that even if your test
		//  pattern is '' it will still match records that are null if
		//  you don't use these funcs then oracle will return no results
		//  if $user = ''; even if there were records that = ''
		//
		//  SELECT * FROM USERS WHERE USER = ".$db->is_equal_str($user)."

		function is_equal_str($str='')
		{
			return ($str==''?'IS NULL':"= '".$this->escape($str)."'");
		}

		function is_equal_int($int)
		{
			return ($int==''?'IS NULL':'= '.$int);
		}

		// ==================================================================
		// If you have set up a sequence this function returns the 
		// next ID from that sequence

		function insert_id($seq_name)
		{
			return $this->get_var("SELECT $seq_name.nextVal id FROM Dual");
		}

		function sysdate()
		{
			return "SYSDATE";
		}

		// ==================================================================
		//	Turn error handling on or off..

		function show_errors()
		{
			$this->show_errors = true;
		}
		
		function hide_errors()
		{
			$this->show_errors = false;
		}

		// ==================================================================
		//	Kill cached query results

		function flush()
		{

			// Get rid of these
			$this->last_result = null;
			$this->col_info = null;
			$this->last_query = null;

		}

		// ==================================================================
		//	Basic Query	- see docs for more detail

		function query($query)
		{

			// For reg expressions
			$query = trim($query); 

			$return_value = 0;

			// Flush cached values..
			$this->flush();

			// Log how the function was called
			$this->func_call = "\$db->query(\"$query\")";

			// Keep track of the last query for debug..
			$this->last_query = $query;

			// Parses the query and returns a statement..
			if ( ! $stmt = OCIParse($this->dbh, $query))
			{
				$this->print_error("Last Query",$query);
			}

			// Execut the query..
			elseif ( ! $this->result = OCIExecute($stmt))
			{
				$this->print_error("Last Query",$query);
			}

			$this->num_queries++;

			// If query was an insert
			if ( preg_match('/^(insert|delete|update|create)\s+/i', $query) )
			{
				// num afected rows
				$return_value = $this->rows_affected = OCIRowCount($stmt);
			}
			// If query was a select
			else
			{

				// Get column information
				if ( $num_cols = @OCINumCols($stmt) )
				{
					// Fetch the column meta data
	    			for ( $i = 1; $i <= $num_cols; $i++ )
	    			{
	    				$this->col_info[($i-1)]->name = OCIColumnName($stmt,$i);
	    				$this->col_info[($i-1)]->type = OCIColumnType($stmt,$i);
	    				$this->col_info[($i-1)]->size = OCIColumnSize($stmt,$i);
				    }
				}

				// If there are any results then get them
				if ($this->num_rows = @OCIFetchStatement($stmt,$results))
				{
					// Convert results into object orientated results..
					// Due to Oracle strange return structure - loop through columns
					foreach ( $results as $col_title => $col_contents )
					{
						$row_num=0;
						// then - loop through rows
						foreach (  $col_contents as $col_content )
						{
							$this->last_result[$row_num]->{$col_title} = $col_content;
							$row_num++;
						}
					}
				}

				// num result rows
				$return_value = $this->num_rows;
			}

			// If debug ALL queries
			$this->trace || $this->debug_all ? $this->debug() : null ;

			return $return_value;

		}

		// ==================================================================
		//	Get one variable from the DB - see docs for more detail

		function get_var($query=null,$x=0,$y=0)
		{

			// Log how the function was called
			$this->func_call = "\$db->get_var(\"$query\",$x,$y)";

			// If there is a query then perform it if not then use cached results..
			if ( $query )
			{
				$this->query($query);
			}

			// Extract var out of cached results based x,y vals
			if ( $this->last_result[$y] )
			{
				$values = array_values(get_object_vars($this->last_result[$y]));
			}

			// If there is a value return it else return null
			return (isset($values[$x]) && $values[$x]!=='')?$values[$x]:null;
		}

		// ==================================================================
		//	Get one row from the DB - see docs for more detail

		function get_row($query=null,$output=OBJECT,$y=0)
		{

			// Log how the function was called
			$this->func_call = "\$db->get_row(\"$query\",$output,$y)";

			// If there is a query then perform it if not then use cached results..
			if ( $query )
			{
				$this->query($query);
			}

			// If the output is an object then return object using the row offset..
			if ( $output == OBJECT )
			{
				return $this->last_result[$y]?$this->last_result[$y]:null;
			}
			// If the output is an associative array then return row as such..
			elseif ( $output == ARRAY_A )
			{
				return $this->last_result[$y]?get_object_vars($this->last_result[$y]):null;
			}
			// If the output is an numerical array then return row as such..
			elseif ( $output == ARRAY_N )
			{
				return $this->last_result[$y]?array_values(get_object_vars($this->last_result[$y])):null;
			}
			// If invalid output type was specified..
			else
			{
				$this->print_error(" \$db->get_row(string query, output type, int offset) -- Output type must be one of: OBJECT, ARRAY_A, ARRAY_N");
			}

		}

		// ==================================================================
		//	Function to get 1 column from the cached result set based in X index
		// se docs for usage and info

		function get_col($query=null,$x=0)
		{

			// If there is a query then perform it if not then use cached results..
			if ( $query )
			{
				$this->query($query);
			}

			// Extract the column values
			for ( $i=0; $i < count($this->last_result); $i++ )
			{
				$new_array[$i] = $this->get_var(null,$x,$i);
			}

			return $new_array;
		}

		// ==================================================================
		// Return the the query as a result set - see docs for more details

		function get_results($query=null, $output = OBJECT)
		{

			// Log how the function was called
			$this->func_call = "\$db->get_results(\"$query\", $output)";

			// If there is a query then perform it if not then use cached results..
			if ( $query )
			{
				$this->query($query);
			}

			// Send back array of objects. Each row is an object
			if ( $output == OBJECT )
			{
				return $this->last_result;
			}
			elseif ( $output == ARRAY_A || $output == ARRAY_N )
			{
				if ( $this->last_result )
				{
					$i=0;
					foreach( $this->last_result as $row )
					{

						$new_array[$i] = get_object_vars($row);

						if ( $output == ARRAY_N )
						{
							$new_array[$i] = array_values($new_array[$i]);
						}

						$i++;
					}

					return $new_array;
				}
				else
				{
					return null;
				}
			}
		}

		// ==================================================================
		// Function to get column meta data info pertaining to the last query
		// see docs for more info and usage

		function get_col_info($info_type="name",$col_offset=-1)
		{

			if ( $this->col_info )
			{
				if ( $col_offset == -1 )
				{
					$i=0;
					foreach($this->col_info as $col )
					{
						$new_array[$i] = $col->{$info_type};
						$i++;
					}
					return $new_array;
				}
				else
				{
					return $this->col_info[$col_offset]->{$info_type};
				}

			}

		}

		// ==================================================================
		// Dumps the contents of any input variable to screen in a nicely
		// formatted and easy to understand way - any type: Object, Var or Array

		function vardump($mixed='')
		{

			echo "<p><table><tr><td bgcolor=ffffff><blockquote><font color=000090>";
			echo "<pre><font face=arial>";

			if ( ! $this->vardump_called )
			{
				echo "<font color=800080><b>ezSQL</b> (v".EZSQL_VERSION.") <b>Variable Dump..</b></font>\n\n";
			}

			$var_type = gettype ($mixed);
			print_r(($mixed?$mixed:"<font color=red>No Value / False</font>"));
			echo "\n\n<b>Type:</b> " . ucfirst($var_type) . "\n";
			echo "<b>Last Query</b> [$this->num_queries]<b>:</b> ".($this->last_query?$this->last_query:"NULL")."\n";
			echo "<b>Last Function Call:</b> " . ($this->func_call?$this->func_call:"None")."\n";
			echo "<b>Last Rows Returned:</b> ".count($this->last_result)."\n";
			echo "</font></pre></font></blockquote></td></tr></table>".$this->donation();
			echo "\n<hr size=1 noshade color=dddddd>";

			$this->vardump_called = true;

		}

		// Alias for the above function
		function dumpvar($mixed)
		{
			$this->vardump($mixed);
		}

		// ==================================================================
		// Displays the last query string that was sent to the database & a
		// table listing results (if there were any).
		// (abstracted into a seperate file to save server overhead).

		function debug()
		{

			echo "<blockquote>";

			// Only show ezSQL credits once..
			if ( ! $this->debug_called )
			{
				echo "<font color=800080 face=arial size=2><b>ezSQL</b> (v".EZSQL_VERSION.") <b>Debug..</b></font><p>\n";
			}
			echo "<font face=arial size=2 color=000099><b>Query</b> [$this->num_queries] <b>--</b> ";
			echo "[<font color=000000><b>$this->last_query</b></font>]</font><p>";

				echo "<font face=arial size=2 color=000099><b>Query Result..</b></font>";
				echo "<blockquote>";

			if ( $this->col_info )
			{

				// =====================================================
				// Results top rows

				echo "<table cellpadding=5 cellspacing=1 bgcolor=555555>";
				echo "<tr bgcolor=eeeeee><td nowrap valign=bottom><font color=555599 face=arial size=2><b>(row)</b></font></td>";


				for ( $i=0; $i < count($this->col_info); $i++ )
				{
					echo "<td nowrap align=left valign=top><font size=1 color=555599 face=arial>{$this->col_info[$i]->type} {$this->col_info[$i]->max_length}</font><br><span style='font-family: arial; font-size: 10pt; font-weight: bold;'>{$this->col_info[$i]->name}</span></td>";
				}

				echo "</tr>";

				// ======================================================
				// print main results

			if ( $this->last_result )
			{

				$i=0;
				foreach ( $this->get_results(null,ARRAY_N) as $one_row )
				{
					$i++;
					echo "<tr bgcolor=ffffff><td bgcolor=eeeeee nowrap align=middle><font size=2 color=555599 face=arial>$i</font></td>";

					foreach ( $one_row as $item )
					{
						echo "<td nowrap><font face=arial size=2>$item</font></td>";
					}

					echo "</tr>";
				}

			} // if last result
			else
			{
				echo "<tr bgcolor=ffffff><td colspan=".(count($this->col_info)+1)."><font face=arial size=2>No Results</font></td></tr>";
			}

			echo "</table>";

			} // if col_info
			else
			{
				echo "<font face=arial size=2>No Results</font>";
			}

			echo "</blockquote></blockquote>".$this->donation()."<hr noshade color=dddddd size=1>";


			$this->debug_called = true;
		}

		// =======================================================
		// Naughty little function to ask for some remuniration!

		function donation()
		{
			return "<font size=1 face=arial color=000000>If ezSQL has helped <a href=\"https://www.paypal.com/xclick/business=justin%40justinvincent.com&item_name=ezSQL&no_note=1&tax=0\" style=\"color: 0000CC;\">make a donation!?</a> &nbsp;&nbsp;[ go on! you know you want to! ]</font>";	
		}

	}

# $db = new db(EZSQL_DB_USER, EZSQL_DB_PASSWORD, EZSQL_DB_NAME );

?>

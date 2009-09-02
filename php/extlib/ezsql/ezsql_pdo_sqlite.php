<?php

	// ==================================================================
	//  Author: Justin Vincent (justin@visunet.ie)
	//	Web: 	Http://php.justinvincent.com
	//	Name: 	ezSQL
	// 	Desc: 	Class to make it very easy to deal with SQLite databases.
	//
	//	N.B. ezSQL was converted for use with SQLite
	//	     by Brennan Falkner (fishy5@tampabay.rr.com).
	//
	// !! IMPORTANT !!
	//
	//  Please send me a mail telling me what you think of ezSQL
	//  and what your using it for!! Cheers. [ justin@visunet.ie ]
	//
	// ==================================================================
	// User Settings -- CHANGE HERE

	define("EZSQL_DB_PATH", $_SERVER['DOCUMENT_ROOT']."/");	// <-- SQLite db path (with trailing slash!!!)
	define("EZSQL_DB_NAME", "");				// <-- SQLite db name

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

		var $debug_called;
		var $vardump_called;
		var $show_errors = true;
		var $num_queries = 0;
		var $debug_all = false;
		var $last_query;
		var $col_info;
		
		// ==================================================================
		//	DB Constructor - connects to the server and selects a database

		function db($dbpath, $dbname)
		{
			try {
				$this->dbh = new PDO('sqlite:' . $dbpath . $dbname);
			} catch (Exception $e) {
				$this->print_error("Error","<ol><b>Error establishing a database!</b><li>Are you sure you have the correct path?<li>Are you sure that you have typed the correct database instance name?<li>Are you sure that the database is installed?</ol>");

			}
		}

		// ==================================================================
		//	Select a DB instance (if another one needs to be selected)

		function select($dbpath, $dbname)
		{
			$this->db($dbpath, $dbname);
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

			// If no error string then you're SOL
			if ( !$str )
			{
				$str = "An error occured, quick go tell someone!";
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

			// Flush cached values..
			$this->flush();

			// Log how the function was called
			$this->func_call = "\$db->query(\"$query\")";

			// Keep track of the last query for debug..
			$this->last_query = $query;

			#if(!sqlite_complete($query)){
			#	$this->print_error("Invalid Query String Format",$query);
			#	return false;
			#}
			
			// Perform the query via std mysql_query function..
			$handle = $this->dbh->query($query);
			#$this->result = sqlite_fetch_array($handle)?true:false;
			$this->result = $handle;
			$this->num_queries++;
			
			// If there was an insert, delete or update see how many rows were affected
			// (Also, If there there was an insert take note of the insert_id
			$query_type = array("insert","delete","update","replace");

			// loop through the above array
			foreach ( $query_type as $word )
			{
				// This is true if the query starts with insert, delete or update
				if ( preg_match("/^$word\s+/i",$query) )
				{
					$this->rows_affected = $handle->rowCount();

					// This gets the insert ID
					if ( $word == "insert" || $word == "replace" )
					{
						$this->insert_id = $this->dbh->lastInsertId();
						
						// If insert id then return it - true evaluation
						return $this->insert_id;
					}

					// Set to false if there was no insert id
					$this->result = false;

				}

			}

			if ( ! $handle )
			{

				// If there is an error then take note of it..
				if ( $php_errormsg )
				{
					$this->print_error($php_errormsg,$query);
				} else {
					$this->print_error("Invalid Query",$query);
				}

			}
			else
			{

				// In other words if this was a select statement..
				if ( $this->result )
				{

					// =======================================================
					// Take note of column info

					#$i=0;
					#foreach(@sqlite_fetch_field_array($handle) as $name)
					#{
					#	$this->col_info[$i++]->name = $name;
					#}

					// =======================================================
					// Store Query Results

					$i=0;
                    while ($row = $handle->fetch(PDO::FETCH_ASSOC)) {
                        $this->last_result[$i++] = (Object) $row;
                    }
                    
					// Log number of rows the query returned
					$this->num_rows = $i;

					// If debug ALL queries
					$this->debug_all ? $this->debug() : null ;

					// If there were results then return true for $db->query
					if ( $i )
					{
						return true;
					}
					else
					{
						return false;
					}

				}
				else
				{
					// If debug ALL queries
					$this->debug_all ? $this->debug() : null ;
					
					// Update insert etc. was good..
					return true;
				}

			}
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

#$db = new db( EZSQL_DB_PATH, EZSQL_DB_NAME );

?>

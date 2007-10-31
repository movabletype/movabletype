/*
 * CodePress regular expressions for PHP syntax highlighting by Martin
 */

// ASP VBScript
Language.syntax = [
	{ input : /(&lt;[^!%|!%@]*?&gt;)/g, output : '<b>$1</b>' }, // all tags
	{ input : /(&lt;style.*?&gt;)(.*?)(&lt;\/style&gt;)/g, output : '<em>$1</em><em>$2</em><em>$3</em>' }, // style tags
	{ input : /(&lt;script.*?&gt;)(.*?)(&lt;\/script&gt;)/g, output : '<ins>$1</ins><ins>$2</ins><ins>$3</ins>' }, // script tags
	{ input : /\"(.*?)(\"|<br>|<\/P>)/g, output : '<s>"$1$2</s>' }, // strings double quote 
	{ input : /\'(.*?)(\'|<br>|<\/P>)/g, output : '<dfn>\'$1$2</dfn>'}, // ASP Comment
	{ input : /(&lt;%)/g, output : '<strong>$1' }, // <%.*
	{ input : /(%&gt;)/g, output : '$1</strong>' }, // .*%>
	{ input : /(&lt;%@)(.+?)(%&gt;)/gi, output : '$1<span>$2</span>$3' }, // <%@...%>
	{ input : /\b([\d]+)\b/g, output : '<var>$1</var>' }, //Numbers
	{ input : /\b(And|As|ByRef|ByVal|Call|Case|Class|Const|Dim|Do|Each|Else|ElseIf|Empty|End|Eqv|Exit|False|For|Function)\b/gi, output : '<a>$1</a>' }, // Reserved Words 1 (Blue)
	{ input : /\b(Get|GoTo|If|Imp|In|Is|Let|Loop|Me|Mod|Enum|New|Next|Not|Nothing|Null|On|Option|Or|Private|Public|ReDim|Rem)\b/gi, output : '<a>$1</a>' }, // Reserved Words 1 (Blue)
	{ input : /\b(Resume|Select|Set|Stop|Sub|Then|To|True|Until|Wend|While|With|Xor|Execute|Randomize|Erase|ExecuteGlobal|Explicit|step)\b/gi, output : '<a>$1</a>' }, // Reserved Words 1 (Blue)
	
	{ input : /\b(Abandon|Abs|AbsolutePage|AbsolutePosition|ActiveCommand|ActiveConnection|ActualSize|AddHeader|AddNew|AppendChunk)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(AppendToLog|Application|Array|Asc|Atn|Attributes|BeginTrans|BinaryRead|BinaryWrite|BOF|Bookmark|Boolean|Buffer|Byte)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(CacheControl|CacheSize|Cancel|CancelBatch|CancelUpdate|CBool|CByte|CCur|CDate|CDbl|Charset|Chr|CInt|Clear)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(ClientCertificate|CLng|Clone|Close|CodePage|CommandText|CommandType|CommandTimeout|CommitTrans|CompareBookmarks|ConnectionString|ConnectionTimeout)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Contents|ContentType|Cookies|Cos|CreateObject|CreateParameter|CSng|CStr|CursorLocation|CursorType|DataMember|DataSource|Date|DateAdd|DateDiff)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(DatePart|DateSerial|DateValue|Day|DefaultDatabase|DefinedSize|Delete|Description|Double|EditMode|Eof|EOF|err|Error)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Exp|Expires|ExpiresAbsolute|Filter|Find|Fix|Flush|Form|FormatCurrency|FormatDateTime|FormatNumber|FormatPercent)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(GetChunk|GetLastError|GetRows|GetString|Global|HelpContext|HelpFile|Hex|Hour|HTMLEncode|IgnoreCase|Index|InStr|InStrRev)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Int|Integer|IsArray|IsClientConnected|IsDate|IsolationLevel|Join|LBound|LCase|LCID|Left|Len|Lock|LockType|Log|Long|LTrim)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(MapPath|MarshalOptions|MaxRecords|Mid|Minute|Mode|Month|MonthName|Move|MoveFirst|MoveLast|MoveNext|MovePrevious|Name|NextRecordset)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Now|Number|NumericScale|ObjectContext|Oct|Open|OpenSchema|OriginalValue|PageCount|PageSize|Pattern|PICS|Precision|Prepared|Property)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Provider|QueryString|RecordCount|Redirect|RegExp|Remove|RemoveAll|Replace|Requery|Request|Response|Resync|Right|Rnd)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(RollbackTrans|RTrim|Save|ScriptTimeout|Second|Seek|Server|ServerVariables|Session|SessionID|SetAbort|SetComplete|Sgn)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Sin|Sort|Source|Space|Split|Sqr|State|StaticObjects|Status|StayInSync|StrComp|String|StrReverse|Supports|Tan|Time)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(Timeout|Timer|TimeSerial|TimeValue|TotalBytes|Transfer|Trim|Type|Type|UBound|UCase|UnderlyingValue|UnLock|Update|UpdateBatch)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)
	{ input : /\b(URLEncode|Value|Value|Version|Weekday|WeekdayName|Write|Year)\b/gi, output : '<u>$1</u>' }, // Reserved Words 2 (Purple)

	{ input : /\b(vbBlack|vbRed|vbGreen|vbYellow|vbBlue|vbMagenta|vbCyan|vbWhite|vbBinaryCompare|vbTextCompare)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
  	{ input : /\b(vbSunday|vbMonday|vbTuesday|vbWednesday|vbThursday|vbFriday|vbSaturday|vbUseSystemDayOfWeek)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
	{ input : /\b(vbFirstJan1|vbFirstFourDays|vbFirstFullWeek|vbGeneralDate|vbLongDate|vbShortDate|vbLongTime|vbShortTime)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
	{ input : /\b(vbObjectError|vbCr|VbCrLf|vbFormFeed|vbLf|vbNewLine|vbNullChar|vbNullString|vbTab|vbVerticalTab|vbUseDefault|vbTrue)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
	{ input : /\b(vbFalse|vbEmpty|vbNull|vbInteger|vbLong|vbSingle|vbDouble|vbCurrency|vbDate|vbString|vbObject|vbError|vbBoolean|vbVariant)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
	{ input : /\b(vbDataObject|vbDecimal|vbByte|vbArray)\b/gi, output : '<i>$1</i>' }, // Reserved Words 3 (Turquis)
	//{ input : /([^:])\/\/(.*?)(<br|<\/P)/g, output : '$1<i>//$2</i>$3' }, // php comments //
	//{ input : /\/\*(.*?)\*\//g, output : '<i>/*$1*/</i>' }, // php comments /* */
	{ input : /(&lt;!--.*?--&gt.)/g, output : '<big>$1</big>' } // html comments
]

Language.snippets = [
	/*{ input : 'if', output : 'if($0){\n\t\n}' },
	{ input : 'ifelse', output : 'if($0){\n\t\n}\nelse{\n\t\n}' },
	{ input : 'else', output : '}\nelse {\n\t' },
	{ input : 'elseif', output : '}\nelseif($0) {\n\t' },
	{ input : 'do', output : 'do{\n\t$0\n}\nwhile();' },
	{ input : 'inc', output : 'include_once("$0");' },
	{ input : 'fun', output : 'function $0(){\n\t\n}' },	
	{ input : 'func', output : 'function $0(){\n\t\n}' },	
	{ input : 'while', output : 'while($0){\n\t\n}' },
	{ input : 'for', output : 'for($0,,){\n\t\n}' },
	{ input : 'fore', output : 'foreach($0 as ){\n\t\n}' },
	{ input : 'foreach', output : 'foreach($0 as ){\n\t\n}' },
	{ input : 'echo', output : 'echo \'$0\';' },
	{ input : 'switch', output : 'switch($0) {\n\tcase "": break;\n\tdefault: ;\n}' },
	{ input : 'case', output : 'case "$0" : break;' },
	{ input : 'ret0', output : 'return false;' },
	{ input : 'retf', output : 'return false;' },
	{ input : 'ret1', output : 'return true;' },
	{ input : 'rett', output : 'return true;' },
	{ input : 'ret', output : 'return $0;' },
	{ input : 'def', output : 'define(\'$0\',\'\');' },
	{ input : '<?', output : 'php\n$0\n?>' }*/
]

Language.complete = [
	//{ input : '\'', output : '\'$0\'' },
	{ input : '"', output : '"$0"' },
	{ input : '(', output : '\($0\)' },
	{ input : '[', output : '\[$0\]' },
	{ input : '{', output : '{\n\t$0\n}' }		
]

Language.shortcuts = [
	{ input : '[space]', output : '&nbsp;' },
	{ input : '[enter]', output : '<br />' } ,
	{ input : '[j]', output : 'testing' },
	{ input : '[7]', output : '&amp;' }
]
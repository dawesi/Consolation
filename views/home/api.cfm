<h2>API for Console</h2>

<p>
<a href="#Conventions">Naming Conventions</a> | 
<a href="#Create">Create</a> | 
<a href="#Scaffold">Scaffold</a> | 
<a href="#Join">Join</a> | 
<a href="#Bind">Bind</a> | 
<a href="#Add">Add</a> | 
<a href="#Drop">Drop</a> |
<a href="#Desc">Desc</a>
</p>



<div class="pod" style="width:100%">
	<div class="C
	onventions"><a name="Create"></a>Naming Conventions</div>
	
	<div class="pod-body">
		<ul>
			<li>Models are all singular</li>
			<li>Words are separated using camelCase. Labels with have spaces, databse columns will have under_scores</li>
			<li>When scaffolding, enter the FK field (ie. "HotelId") and scaffold will build a dropdown box with that table as the list</li>
			<li>Columns from joined tables are aliased with "{column_name}From{column_table}" such as "nameFromHotels". You can easilty update your listing views from IDs to names using the convention. Aliases will be truncated if over 30 characters to avoid Oracle errors.</li>
		</ul>
		
		
	
	</div>

</div>


<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Create"></a>Create</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use the create command to generate a table based on your model. Properties map to column names. Data types are:
		
		<ul>
			<li>string ( varchar2(50) )</li>
			<li>text ( varchar2(500) )</li>
			<li>date ( date default sysdate )</li>
			<li>number ( number(6) )</li>
			<li>boolean ( number(1) default 0 )</li>
		</ul>
		</p>
		
		<p>You can alter your table column attributes prior to scaffolding. The Scaffolder reads column properites from the database, not your model declaration. 
		If you do not add a datatype it will default to string</p>
	
		<p>Syntax:<br/>
		<b>CREATE</b> {model name}<b> (</b> {property name} {data type} <b>,</b>{property name} {data type} <b>)</b> 		
		</p>
	
	
		<p>Example:<br/>
		CREATE hotel( Name string , description text , street string, city string , state string, zip_code int, total_rooms int )</b> 		
		</p>
	
	
	
	</div>

</div>



<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Scaffold"></a>Scaffold</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use the Scaffold command to generate code based on the model (table) that you created. You can scaffold all files or individual files. The "Service" layer is not
		generated with "all", you must generate that explicitly</P> 
		
		<p>Options are:
		
		<ul>
			<li>All</li>
			<li>Model</li>
			<li>Controller</li>
			<li>Default</li>
			<li>Add</li>
			<li>Edit</li>
			<li>Sort</li>
			<li>Service</li>
		</ul>
		</p>
		
		<p>You can add a ":required" to any properites you want to be required in forms.</p>
		
		<p>You can also create aliases for column names by adding the actual column name in brackets next to the column name. For instance, a column called "Hotel_Name_short" could be aliased
		with "hotelName" but typing hotelName[hotel_name_short].</p>
		
		<p>Syntax:<br/>
		<b>SCAFFOLD ALL</b> {model name}<b> (</b> {property name}{[real_column]}:required <b>,</b>{property name} <b>)</b> 		
		</p>
	
	
		<p>Example:<br/>
		SCAFFOLD CONTROLLER hotel( Name[hotel_name_short]:required , description[hotel_description], state:required, zip_code:required, total_rooms:required)</b> 		
		</p>
	
		<p>Hint: Use the DESC command to get a list of properties and use the links (within the status pain) to build your scaffold command.</p>
	
	
	</div>

</div>



<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Join"></a>Join</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use JOIN to join on model to another. It will create a foriegn key and a foreign key constraint. The scaffolder will also
		recognize the relation and create drop down lists in the edit and add forms.</p>
		
		<p>The result will be that the first model will have a foreign key column added to it to link it in a one to many 
		relationship with the second model</p>
		
	
		<p>Syntax:<br/>
		<b>JOIN</b> {model name}<b> TO </b>  {model name}</p>
	
	
		<p>Example:<br/>
		JOIN room TO hotel
		</p>
	
		<p>Result will by that room will have a hotel_id column added to it</p>
	
	</div>

</div>



<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Bind"></a>Bind</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use bind to create a many to many relationship between models using a third table. If you want extra fields in the bind table add parameters in () after the bind table.
		Otherwise leave the () with nothing in them.
		</p>
	
		<p>Syntax:<br/>
		<b>BIND</b> {model name}<b> AND </b>  {model name} USING {table name} ({parameters using the create model pattern})</p>
	
	
		<p>Example:<br/>
		Bind Guest and Room USING  reservation (amount int, arrivalDate date )
		</p>
	
	</div>

</div>


<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Add"></a>Add</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use ADD to add a property/column to a model/table
		</p>
	
		<p>Syntax:<br/>
		<b>ADD</b> <b>TO</b> {model name} (parameter using model pattern) </p>
	
	
		<p>Example:<br/>
		<b>ADD</b> <b>TO</b> room (description text) </p>
		</p>
	
	</div>

</div>


<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Drop"></a>Drop</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use DROP to remove a table and files from your application. It will remove all files related to the model,
		the database table, and the sql captured from the previous create model command.
		</p>
	
		<p>Syntax:<br/>
		<b>DROP</b> {model name} </p>
	
	
		<p>Example:<br/>
		<b>DROP</b> room </p>
		</p>
	
	</div>

</div>




<div class="pod" style="width:100%">
	<div class="pod-title"><a name="Desc"></a>Desc</div>
	
	<div class="pod-body">
		<p>Use:</p>
		<p>		
		Use the DESC command to return the database column information for a model.
		</p>
	
		<p>Syntax:<br/>
		<b>DESC</b> {model name}</p>
	
	
		<p>Example:<br/>
		desc room
		</p>
	
	</div>

</div>

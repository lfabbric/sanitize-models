<cfsetting enablecfoutputonly="true">
<style type="text/css">
table {
	border: 1px solid #ccc;
	margin-bottom: 20px;
}
	table caption {
		font-weight: bold;
		text-align: left;
	}

	table thead tr th,
	table tbody tr td {
		padding: 3px;
	}

	table thead tr th {
		border-bottom: 1px solid #ccc;
	}

	table tbody tr.highlight {
		background: #eee;
	}
    ol {
    	margin: 0 0 20px 30px;
    }
</style>
<cfoutput>



<h1>Sanitize Objects v1.0.0</h1>
<p>The <tt>SanitizeModels</tt> plugin provides a utitlity to render objects and exclude sensitive information prior to displaying.  For example, you may have a field in the users table containing a hashed password and the lastipaddress of the user who logged in.  This plugin will hide those from views.</p>

<h2>Usage</h2>
<h4>config/settings.cfm</h4>
<pre>
&lt;cfset set(functionName="renderWith", sanitize=True)&gt;
...
</pre>

or you can call directly
<pre>
##renderWith(data=item, sanitize=True);&gt;
...
</pre>


<h2>Setup Models</h2>
<p>Within your models, you will want to determine which fields should be excluded.</p>
<pre>
    component extends="Model" {

        public function init() {
            table("tableName");
            ...
            excludeFields(['hashedpassword','lastipaddress', 'updatedat']);
            return this;
        }
        ...
    }
</pre>

</cfoutput>

<cfsetting enablecfoutputonly="false">

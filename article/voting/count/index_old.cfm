<cfsavecontent variable="IdeaHeadFunction">
<script type="text/javascript">
	function VoteIdea(IdeaID,Direction)
	{
		$.ajax({
			type: "GET",
			url: "/article/voting/ajax/ideas.cfm",
			data: "Action=Vote&Direction=" + Direction + "&IdeaID=" + IdeaID,
			success: function(result) {
					if ( result.indexOf('error') == -1)
					{
						//Update + clear vote container upon successful submission 
						$('#votes-container_'+IdeaID).html("<h4>Thanks for voting!</h4>");
					}
				}
			});
	};
</script>

<style>
	.idea-container {padding-top: 15px; padding-bottom: 15px;}
	.idea-author {padding-top: 10px; font-style: italic; }
	.idea-votes-elements {float: left; color: navy;}
	div.vote-text {margin-top: 5px;}
	.idea-image {float: left; margin: 0 5px 5px 0;}
</style>
</cfsavecontent>
<cfhtmlhead text="#IdeaHeadFunction#">

<!--- 0.1 - Queries to order by votes

/* UP Votes */
Select a.ID, count(b.ID) as Votes
From bizmag_ideas a
Inner Join bizmag_ideas_Votes b ON (a.ID = b.IdeaID AND b.Type = 'Up')
Group By a.ID
Order By count(b.ID) DESC

/* Down Votes */
Select a.ID, count(b.ID) as Votes
From bizmag_ideas a
Inner Join bizmag_ideas_Votes b ON (a.ID = b.IdeaID AND b.Type = 'Down')
Group By a.ID
Order By count(b.ID) DESC

/* Net Votes */
Select a.ID, count(b.ID) as UpVotes, count(c.ID) as DownVotes, (count(b.ID) - count(c.ID)) as NetVotes
From bizmag_ideas a
Left OUTER Join bizmag_ideas_Votes b ON (a.ID = b.IdeaID AND b.Type = 'Up')
Left OUTER Join bizmag_ideas_Votes c ON (a.ID = c.IdeaID AND c.Type = 'Down')
Group By a.ID
Order By (count(b.ID) - count(c.ID)) DESC

 --->

<!--- 1. Query Ideas table in database to retrieve information about stored ideas. Join on previous votes from this IP address. Results are in randomized order --->
<cfquery datasource="#application.dsn#" name="gettop5">
SELECT     TOP (5) a.ID, COUNT(b.ID) AS UpVotes, COUNT(c.ID) AS DownVotes, COUNT(b.ID) - COUNT(c.ID) AS NetVotes
FROM         bizmag_ideas AS a LEFT OUTER JOIN
                      bizmag_ideas_votes AS b ON a.ID = b.IdeaID AND b.Type = 'Up' LEFT OUTER JOIN
                      bizmag_ideas_votes AS c ON a.ID = c.IdeaID AND c.Type = 'Down'
GROUP BY a.ID
ORDER BY NetVotes DESC
</cfquery>
<cfquery datasource="#application.dsn#" name="ideas">
	Select a.ID, a.Title, a.Body, a.Author, a.Image, IsNull(b.ID,0) as VoteID
	From bizmag_ideas a
	Left Join bizmag_ideas_Votes b ON (a.ID = b.IdeaID AND b.IP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">)
    WHERE a.ID IN (#ValueList(gettop5.ID)#)
</cfquery>

<cfif ideas.RecordCount>
	<cfloop query="ideas">
		<cfoutput>
			<p class="idea-container" id="idea_#ideas.ID#">
				<div class="idea-title"><cfif IsDefined("Ideas.Title") AND Len(Ideas.Title)><h3>#ideas.Title#</h3></cfif></div>
				<div class="idea-body">
					<p>
					<cfif IsDefined("Ideas.Image")>
						<img class="idea-image" src="/article/voting/images/#Ideas.Image#" />
					</cfif>
					<cfif IsDefined("Ideas.Body") AND Len(Ideas.Body)>#ideas.Body#</cfif>
					</p>
				</div>
				<div class="idea-author"><cfif IsDefined("Ideas.Author") AND Len(Ideas.Author)>#ideas.Author#</cfif></div>
				<!--- <div id="votes-container_#Ideas.ID#" class="idea-votes">
					<cfif IsDefined("Ideas.VoteID") AND Ideas.VoteID NEQ 0>
						<!--- Display the success message if there's already a vote from this IP --->
						<h4>Thanks for voting!</h4>
					<cfelse>
						<!--- Display the JS block for voting --->
						<div class="idea-votes-elements"><a href="javascript:void(0);" onClick="VoteIdea(#Ideas.ID#,'Up');"><img src="/article/voting/images/ThumbsUp.png" border="0" /></a></div>
						<div class="idea-votes-elements vote-text">&nbsp; VOTE &nbsp;</div>
						<div class="idea-votes-elements"><a href="javascript:void(0);" onClick="VoteIdea(#Ideas.ID#,'Down');"><img src="/article/voting/images/ThumbsDown.png" border="0" /></a></div>
					</cfif>
				</div> --->
			</p>
		</cfoutput>
	</cfloop>
<cfelse>
	<cfoutput>No ideas found in database</cfoutput>
</cfif>
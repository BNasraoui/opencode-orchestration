---
description: Manage issue tracker tickets - create, update, comment, and follow workflow patterns
agent: plan
permissions:
  edit: allow
  bash: allow
---

# Issue Tracker Management

You are tasked with managing issue tracker tickets, including creating tickets from thoughts documents, updating existing tickets, and following team's specific workflow patterns. This command is designed to work with any issue tracking system (GitHub Issues, Jira, Linear, etc.).

## Initial Setup

When this command is invoked:

1. **Check for issue tracker integration**:
   - Look for available issue tracker tools (GitHub CLI, Jira CLI, etc.)
   - If no tools available, respond with setup instructions
   - Detect which issue tracker is being used based on available tools

2. **Respond based on user's request**:
   ```
   I can help you with issue tracker tickets. What would you like to do?
   1. Create a new ticket from a thoughts document
   2. Add a comment to a ticket (I'll use our conversation context)
   3. Search for tickets
   4. Update ticket status or details
   5. List recent tickets
   ```

## Process Steps

### Step 1: Ticket Creation from Thoughts

1. **Locate and read the thoughts document**:
   - If given a path, read the document directly
   - If given a topic/keyword, search thoughts/ directory using Grep to find relevant documents
   - If multiple matches found, show list and ask user to select
   - Create a TodoWrite list to track: Read document → Analyze content → Draft ticket → Get user input → Create ticket

2. **Analyze document content**:
   - Identify the core problem or feature being discussed
   - Extract key implementation details or technical decisions
   - Note any specific code files or areas mentioned
   - Look for action items or next steps
   - Take time to understand the essence of this document into a clear problem statement and solution approach

3. **Check for related context**:
   - If the document references specific code files, read relevant sections
   - If it mentions other thoughts documents, quickly check them
   - Look for any existing tickets mentioned

4. **Draft ticket summary**:
   Present a draft to the user:

   ```
   ## Draft Issue Tracker Ticket

   **Title**: [Clear, action-oriented title]

   **Description**:
   [2-3 sentence summary of problem/goal]

   ## Key Details
   - [Bullet points of important details from thoughts]
   - [Technical decisions or constraints]
   - [Any specific requirements]

   ## Implementation Notes (if applicable)
   [Any specific technical approach or steps outlined]

   ## References
   - Source: `thoughts/[path/to/document.md]`
   - Related code: [any file:line references]
   - Parent ticket: [if applicable]

   ---
   Based on document, this seems to be at the stage of: [ideation/planning/ready to implement]
   ```

5. **Interactive refinement**:
   Ask the user:
   - Does this summary capture the ticket accurately?
   - What priority should this have? (Default: Medium)
   - Any additional context to add?
   - Should we include more/less implementation detail?
   - Which project/area should this go in?

6. **Create the ticket** using available tools:
   - **GitHub Issues**: Use `!gh issue create` with appropriate flags
   - **Jira**: Use Jira CLI or API calls
   - **Linear**: Use MCP tools if available
   - **Generic**: Provide formatted output for manual creation

### Step 2: Adding Comments and Updates

1. **Determine which ticket**:
   - Use context from the current conversation to identify the relevant ticket
   - If uncertain, search for recent tickets and ask user to select
   - Look for ticket references in recent work discussed

2. **Format comments for clarity**:
   - Keep comments concise (~10 lines) unless more detail is needed
   - Focus on key insights or most useful information for human readers
   - Include relevant file references with backticks and links
   - Use OpenCode's `@filename` and `!command` capabilities

3. **Comment structure example**:

   ```markdown
   Implemented retry logic in webhook handler to address rate limit issues.

   Key insight: The 429 responses were clustered during batch operations,
   so exponential backoff alone wasn't sufficient - added request queuing.

   Files updated:

   - `hld/webhooks/handler.go` (analyzed with @analyzer)
   - `thoughts/shared/rate_limit_analysis.md`
   ```

4. **Update ticket using available tools**:
   - **GitHub**: `!gh issue comment --body "comment text"`
   - **Jira**: Use Jira CLI or API
   - **Linear**: Use MCP tools if available

### Step 3: Ticket Search and Management

1. **Gather search criteria**:
   - Query text
   - Project/area filters
   - Status filters
   - Date ranges

2. **Execute search** using available tools:
   - **GitHub**: `!gh issue list --search "query" --limit 20`
   - **Jira**: Use Jira search CLI
   - **Linear**: Use MCP tools if available

3. **Present results**:
   - Show ticket ID, title, status, assignee
   - Group by project if multiple projects
   - Include direct links to tickets

## OpenCode-Specific Enhancements

### File Reference System

- Use `@filename` to include relevant files in ticket creation
- Reference specific file:line numbers in tickets
- Include code snippets directly in ticket descriptions
- Link to relevant documentation or plans

### Git Integration

- Use `!git log` to find related commits
- Include commit references in tickets
- Link specific commits to ticket updates
- Use `!git diff` to analyze changes for ticket updates

### Multi-Provider Support

- Work with any issue tracker (GitHub, Jira, Linear, etc.)
- Adapt to available tools automatically
- Provide fallback manual creation when tools unavailable
- Support multiple trackers in same workflow

### Research Integration

- Use `@locator` to find files related to ticket topic
- Use `@analyzer` to understand implementation details
- Use `@researcher` to find related thoughts documents
- Include research findings in ticket descriptions

## Team Workflow Patterns

### Common Workflow States

Most teams follow a progression like:

1. **Triage/Backlog** → Initial review and prioritization
2. **Ready for Research** → Problem understood, needs investigation
3. **In Research** → Active investigation underway
4. **Ready for Planning** → Research complete, needs implementation plan
5. **In Planning** → Creating detailed implementation plan
6. **Ready for Development** → Plan approved, ready to implement
7. **In Development** → Active implementation
8. **In Review** → Code review or testing phase
9. **Ready for Deploy** → Implementation complete, ready for release
10. **Done** → Completed and deployed

### Automatic Label Assignment

Apply labels based on ticket content:

- **backend**: For tickets about server-side code, APIs, databases
- **frontend**: For tickets about UI, UX, client-side code
- **infrastructure**: For tickets about deployment, CI/CD, monitoring
- **documentation**: For tickets about docs, guides, README files
- **bug**: For tickets fixing broken functionality
- **enhancement**: For tickets adding new features
- **performance**: For tickets about speed, optimization

## Success Criteria

### Automated Verification:

- [ ] Ticket created/updated successfully
- [ ] All referenced files exist and are accessible
- [ ] Links and references are properly formatted
- [ ] Commands executed without errors
- [ ] Git references are accurate

### Manual Verification:

- [ ] Ticket title is clear and action-oriented
- [ ] Description accurately captures the problem and solution
- [ ] Technical details are sufficient for implementation
- [ ] References and links are helpful and correct
- [ ] Priority and labels are appropriate

## Error Handling

### If Issue Tracker Tools Fail:

- Check authentication: `!gh auth status` for GitHub
- Verify repository access: `!gh repo view`
- Provide manual creation instructions
- Suggest alternative approaches

### If Document Analysis Fails:

- Ask user for more specific document path
- Offer to analyze multiple documents
- Request clarification on ticket content
- Provide template for manual ticket creation

## Example Workflows

### Creating a Ticket from Thoughts:

```
User: @ticket thoughts/shared/research/auth-flow.md

Assistant: I'll create a ticket from your thoughts document.

[Reads document, analyzes content]

## Draft Ticket

**Title**: Implement OAuth2 authentication flow

**Description**:
Add secure OAuth2 authentication to support external identity providers...

## Key Details
- Use OAuth2 standard with PKCE
- Support Google, GitHub, Microsoft providers
- Store tokens securely in database
- Implement refresh token rotation

Ready to create this ticket? (y/n)
```

### Adding a Comment:

```
User: @ticket comment "Fixed the authentication bug"

Assistant: I'll add a comment to the relevant ticket.

[Identifies ticket from context, formats comment]

Added comment to #123:
"Fixed authentication token validation by adding proper JWT signature verification.

Key insight: The previous implementation wasn't checking the 'alg' header,
causing validation failures for tokens with different algorithms.

Files updated:
- `hld/auth/jwt.go:45-67`"
```

## Notes

- Adapts to any issue tracking system based on available tools
- Integrates with OpenCode's file reference and research capabilities
- Provides structured workflow for ticket management
- Supports both creation and updates of existing tickets
- Includes automatic label assignment and workflow progression
- Enables seamless integration between thoughts documents and issue tracking

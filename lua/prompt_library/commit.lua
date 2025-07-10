return {
  strategy = 'workflow',
  description = 'Git commit workflow',
  opts = {
    index = 6,
    is_default = true,
    short_name = 'gcm',
  },
  prompts = {
    {
      {
        role = 'system',
        content = function()
          return [[

You are an expert Git commit message generator. You will help create conventional commit messages based on staged changes.

Follow the Conventional Commits specification:
- Format: <type>[optional scope]: <description>
- Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
- Keep description under 50 characters
- Use imperative mood (e.g., "add" not "added")
- Don't capitalize the first letter of description
- No period at the end

Examples:
- feat(auth): add user login validation
- fix: resolve memory leak in parser
- docs: update installation guide
- refactor(api): simplify error handling
- test: add unit tests for utils module

Tools:
- @{web_search} to search for the conventional commits specification.
- @{cmd_runner} to run git commands to stage files, get diffs, and commit.
]]
        end,
        opts = {
          visible = false,
        },
      },
      {
        role = 'user',
        content = function()
          return [[
          Stage all files, then get the diff of those files and generate a commit message.
          Using the generate message, execute the git commit command.
          ]]
        end,
      },
    }, -- first group
  },
}

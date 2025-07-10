return {
  strategy = 'workflow',
  description = 'Use chat to generate a commit message',
  opts = {
    index = 5,
    short_name = 'commit',
    auto_submit = true,
    is_slash_command = true,
  },
  references = {},
  prompts = {
    {
      {
        role = 'system',
        content = function(context)
          return [[You are a **senior software engineer** with experience in crafting great commit messages.
                        You are able to review the staged code and provide a concise and complete commit message following best practices.]]
        end,
        opts = {
          auto_submit = true,
          visible = false,
        },
      },
      {
        role = 'user',
        content = function()
          return [[
        /git_status

        ask me which files I want to state, assigning a number to each file
        
        ]]
        end,
      },
      {
        role = 'user',
        content = [[Stage the selected files using the tool @{cmd_runner}]],
      },
    },
    {
      {
        role = 'user',
        content = [[
Please review the changes staged using /git_diff

- Assess the commit message language used in the previous messages using /git_log then
write the message in that language.
- Use the Conventional Commit Specification
]],
        opts = {
          auto_submit = true,
          visible = false,
          max_tokens = 10000,
        },
      },
      {
        role = 'user',
        content = [[
       Use @{cmd_runner} to commit the changes using the generated commit message.
      ]],
        opts = {
          auto_submit = true,
          visible = true,
        },
      },
    },
  },
}

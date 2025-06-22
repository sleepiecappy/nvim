return {
  strategy = 'chat',
  description = 'Use chat to review and improve your code',
  opts = {
    index = 4,
    short_name = 'cr',
    auto_submit = true,
    is_slash_command = true,
  },
  references = {},
  prompts = {
    {
      role = 'system',
      content = function(context)
        return string.format(
          [[You are a **senior software engineer** with experience in code review using the programming language %s.
                        You are able to review the code and provide feedback on its quality, security, potential issues, edge cases, and improvements.]],
          context.filetype
        )
      end,
      opts = {
        auto_submit = true,
        visible = false,
      },
    },
    {
      role = 'user',
      content = [[
Please review the code I provide in #buffer

- Provide concise feedback on the code quality, security, potential issues, edge cases, and improvements.
- Apply the improvements to the code using @insert_edit_into_file
]],
      opts = {
        auto_submit = true,
        visible = true,
        max_tokens = 10000,
      },
    },
  },
}

return {
  strategy = 'workflow',
  description = 'Use workflow to create and test yourt code',
  opts = {
    index = 5,
    short_name 'wt',
  },
  prompts = {
    {
      {
        role = 'system',
        content = function(context)
          return string.format(
            [[You are a **senior software engineer** with experience in testing using the programming language %s.
          You are able to construct a suite of tests from the input the USER provides.]],
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
          Please create a suite of tests for the code I provide. 
          - The tests should cover all **edge cases**, it must be **concise** and targeted. Make sure it to be written in the same programming language as the code, and using it's **best practices**.

          - After the tests are created, analyse them as a Quality Assurance
          engineer and provide feedback on the code quality, potential issues, and improvements.

          - Apply the improvements to the code and provide the final version of the code.

          The code is:

          <code>
          #buffer.
          </code>
        ]],
        opts = {
          auto_submit = true,
          visible = false,
          max_tokens = 10000,
        },
      },
    },
  },
}

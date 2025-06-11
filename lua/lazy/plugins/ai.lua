return {
  {
    'kiddos/gemini.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gemini').setup {
        api_key = os.getenv 'GEMINI_API_KEY',
        prompts = {
          instructions = {
            prompts = {
              name = 'Unit Test',
              command_name = 'GeminiUnitTest',
              menu = 'Unit Test',
              get_prompt = function(lines, bufnr)
                local code = table.concat(lines, '\n')
                local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
                local prompt = [[
As a senior software engineer, write comprehensive
unit tests for the following code written in %s.

**Key Requirements:**
* Achieve 100%% test coverage for all functions and methods.
* Include tests for edge cases, invalid inputs, and potential error conditions.
* Generate mock objects for any external dependencies.
* Adhere to best practices for unit testing in %s.

**Code:**
```%s
%s
```
]]
                return string.format(prompt, ft, ft, ft, code)
              end,
            },
          },
        },
      }
    end,
  },
}

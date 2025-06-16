return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  config = function()
    require('codecompanion').setup {
      log_level = 'DEBUG',
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'gemini-2.5-pro',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      display = {
        action_palette = {
          provider = 'telescope',
        },
      },
      prompt_library = {
        ['Flutter Test'] = {
          strategy = 'chat',
          description = 'Complete prompt to generate tests',
          opts = {
            user_prompt = true,
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                return [[You are an expert Software Quality Assurance Engineer AI.
                Your primary function is to write concise, effective,
                and high-coverage unit tests for a ]] .. context.filetype .. [[ code file.]]
              end,
            },
            {
              role = 'user',
              opts = {
                contains_code = true,
              },
              content = function(context)
                local prompt = [[
Analyze the provided source code and generate a complete suite of unit tests. You must adhere to the following instructions and best practices for the language in use.

**Core Instructions:**

1.  **Create Test File**: You **must** use the special @create_file command to write the generated test code into a new file.

2.  **Directory and File Naming**:
    * The test file must be created in the corresponding test directory for the project structure (e.g., `test/` for Flutter/Dart).
    * The test file's name must be the original source filename, prefixed with `test_`.
    * The path given to the tool must be relative to the inside of the root directory and not the absolute path, e.g. `test/feature_test.dart` instead of `C:\Users\myuser\code\myapp\test\feature_test.dart`
    * Crucially, if the target directory path does not exist, you must create it before creating the file to prevent errors.

3.  **Testing Best Practices**:
    * **Coverage**: Aim for high test coverage, including success paths, edge cases, and error handling.
    * **Independence**: Each test must be independent and self-contained. Do not rely on the state or outcome of other tests.
    * **Readability**: Write clean, readable, and well-documented test code. Use descriptive names for your test functions that clearly state what they are testing.
    * **Mocking**: Isolate the unit of code under test. Use mock objects or stubs for external dependencies (e.g., network clients, databases, services).
    * **Assertions**: Use relevant assertion functions to verify the behavior and output of the code. Ensure your assertions are precise.
    * **Structure**: Group related tests together, following the convention of the language's testing framework (e.g., using `group()` in Dart).

---

### **Examples for Flutter/Dart**

Below are examples demonstrating the correct directory and file creation for a Flutter project.

**Example 1: A file at the root of `lib/`**

* **Given the source file path:**
    `my_flutter_app/lib/calculator.dart`

* **You will create the test file at:**
    `@create_file my_flutter_app/test/test_calculator.dart`

**Example 2: A file in a subdirectory of `lib/`**

* **Given the source file path:**
    `my_flutter_app/lib/src/ui/widgets/custom_button.dart`

* **You will create the test file at:**
    `@create_file my_flutter_app/test/src/ui/widgets/test_custom_button.dart`
    *(You must ensure the `test/src/ui/widgets/` directory structure is created if it does not already exist.)*

**Example 3: A file for a specific feature screen**

* **Given the source file path:**
    `my_awesome_app/lib/features/authentication/presentation/bloc/auth_bloc.dart`

* **You will create the test file at:**
    `@create_file my_awesome_app/test/features/authentication/presentation/bloc/test_auth_bloc.dart`
    *(Again, you must ensure the nested directory structure under `test/` is created.)*

---

**Your Task:**

Now, analyze the following source code file located at #buffer and generate the corresponding test file.]]
                return prompt
              end,
            },
          },
        },
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  keys = {
    { '<leader>aii', '<cmd>CodeCompanion<cr>', desc = 'CodeCompanion Inline assistant', mode = { 'n', 'v' }, noremap = true },
    { '<leader>aic', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'CodeCompanion Chat', mode = { 'n', 'v' }, noremap = true },
    { '<leader>aim', '<cmd>CodeCompanionCmd<cr>', desc = 'CodeCompanion Command', mode = { 'n', 'v' }, noremap = true },
    { '<leader>ai', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion Actions', mode = { 'n', 'v' }, noremap = true },
  },
}

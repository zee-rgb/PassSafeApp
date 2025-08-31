**Add rules to help the model understand your coding preferences, including preferred frameworks, coding styles, and other conventions.**
**Note: This file only applies to the current project, with each file limited to 10,000 characters. If you do not need to commit this file to a remote Git repository, please add it to .gitignore.**
Preferred language: Ruby  
Framework: Ruby on Rails 8

Coding style:
- Follow the Ruby Style Guide and idiomatic Ruby practices.
- Use modern Rails conventions (Hotwire, Turbo, Zeitwerk).
- Structure code for readability and maintainability.
- Apply DRY, SOLID, and convention over configuration principles.
- Use service objects, concerns, and background jobs appropriately.

Testing:
- Prefer RSpec for unit, integration, and system tests.
- Use FactoryBot for test data setup.

Output preferences:
- Use a professional, concise tone.
- Include minimal but helpful comments.
- Ensure code snippets are executable and Rails 8-compliant.

## RuboCop & GitHub Linting Rules

### GitHub Compatibility Requirements
- **String literals**: Use double quotes `"string"` not single quotes `'string'`
- **Array brackets**: Use spaces inside `[ :item, :other ]` not `[:item, :other]`
- **Test locally**: Run `bin/rubocop --format github` to see what GitHub will see
- **Configure for strictest environment**: Set up rules for GitHub/CI first, then adjust for local preferences

### RuboCop Configuration Best Practices
- **Start with `inherit_gem: { rubocop-rails-omakase: rubocop.yml }`** for Rails projects
- **Override only necessary rules** to match team preferences
- **Test configuration changes** with both local and GitHub formatters
- **Use consistent formatting** across entire project

### Troubleshooting Workflow
- **When GitHub fails but local passes**: Check formatter differences
- **Use `bin/rubocop --format github`** to test GitHub compatibility
- **Look for cached/old versions** if fixes don't resolve issues
- **Commit and push** to force GitHub to re-check files

# Contributing to LetsHab.com

Thank you for your interest in contributing to LetsHab.com! We welcome contributions from everyone. This document provides guidelines and instructions for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Reporting Issues](#reporting-issues)

---

## Code of Conduct

We are committed to providing a welcoming and inspiring community for all. Please read and follow our [Code of Conduct](./CODE_OF_CONDUCT.md).

---

## Getting Started

### 1. Fork the Repository

Click the "Fork" button on the GitHub repository page.

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/letshab.com.git
cd letshab.com
```

### 3. Add Upstream Remote

```bash
git remote add upstream https://github.com/Devopsbaloch12/letshab.com.git
```

### 4. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b bugfix/your-bugfix-name
```

### 5. Install Dependencies

```bash
npm install
# or
yarn install
```

### 6. Setup Environment

```bash
cp .env.example .env.local
# Edit .env.local with your configuration
```

---

## Development Workflow

### 1. Keep Your Branch Updated

```bash
git fetch upstream
git rebase upstream/main
```

### 2. Make Your Changes

- Write clean, readable code
- Follow the [Coding Standards](#coding-standards)
- Include tests for new features
- Update documentation as needed

### 3. Run Tests Locally

```bash
npm run test
npm run test:integration
npm run lint
```

### 4. Commit Your Changes

See [Commit Guidelines](#commit-guidelines) below.

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

---

## Commit Guidelines

We follow the Conventional Commits specification for commit messages.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (formatting, missing semicolons, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Code change that improves performance
- `test`: Adding missing tests or updating existing tests
- `chore`: Changes to build process, dependencies, or tooling
- `ci`: Changes to CI/CD configuration

### Scope

Scope should specify what area of the codebase is affected:
- `auth`: Authentication module
- `crm`: CRM functionality
- `api`: API endpoints
- `voice-agent`: Voice agent functionality
- `integrations`: Third-party integrations
- `db`: Database-related changes
- etc.

### Subject

- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period (.) at the end
- Maximum 50 characters

### Examples

```
feat(auth): implement SSO with Google OAuth

fix(crm): resolve contact creation validation error

docs(readme): update installation instructions

refactor(api): improve error handling middleware

test(voice-agent): add unit tests for tool calling
```

---

## Pull Request Process

### 1. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 2. Create a Pull Request

- Go to the original repository on GitHub
- Click "New Pull Request"
- Select your fork and branch
- Fill in the PR template with details

### 3. PR Title

Follow the same format as commit messages:
```
feat(scope): description
```

### 4. PR Description

Include:
- **What**: Brief description of changes
- **Why**: Reason for the changes
- **How**: Technical approach
- **Testing**: How to test the changes
- **Related Issues**: Reference any related issues (#123)

### 5. Address Feedback

- Respond to review comments
- Push updates to the same branch
- Re-request review after making changes

### 6. Merge

Maintainers will merge your PR once approved and all checks pass.

---

## Coding Standards

### JavaScript/TypeScript

#### ESLint Configuration

```bash
npm run lint
npm run lint:fix
```

#### Prettier Formatting

```bash
npm run format
```

#### Code Style

- Use 2-space indentation
- Use semicolons
- Use single quotes for strings
- Use arrow functions when appropriate
- Use const/let (avoid var)

#### Example

```typescript
// Good
const getUserById = async (id: string): Promise<User> => {
  const user = await db.users.findById(id);
  if (!user) {
    throw new NotFoundError('User not found');
  }
  return user;
};

// Bad
var getUserById = function(id) {
  let user = db.users.findById(id)
  if (!user) {
    throw new Error("User not found")
  }
  return user
}
```

### Comments

- Write meaningful comments
- Explain the "why" not the "what"
- Use JSDoc for functions

```typescript
/**
 * Fetch user by ID from database
 * @param {string} id - User ID
 * @returns {Promise<User>} User object
 * @throws {NotFoundError} If user doesn't exist
 */
const getUserById = async (id: string): Promise<User> => {
  // Implementation
};
```

### Error Handling

```typescript
// Good
try {
  const result = await operation();
  return result;
} catch (error) {
  logger.error('Operation failed', { error, context });
  throw new CustomError('Operation failed', { cause: error });
}
```

---

## Testing

### Write Tests

Tests should be placed alongside source files:

```
src/
  modules/
    users/
      users.service.ts
      users.service.test.ts
      users.controller.ts
      users.controller.test.ts
```

### Test Example

```typescript
describe('UserService', () => {
  describe('getUserById', () => {
    it('should return user when found', async () => {
      const userId = '123';
      const expectedUser = { id: userId, name: 'John' };
      
      jest.spyOn(db.users, 'findById').mockResolvedValue(expectedUser);
      
      const result = await userService.getUserById(userId);
      
      expect(result).toEqual(expectedUser);
    });

    it('should throw error when user not found', async () => {
      jest.spyOn(db.users, 'findById').mockResolvedValue(null);
      
      await expect(userService.getUserById('invalid-id')).rejects.toThrow(NotFoundError);
    });
  });
});
```

### Run Tests

```bash
# All tests
npm run test

# Watch mode
npm run test:watch

# Coverage
npm run test:coverage

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e
```

---

## Documentation

### Update README

If your changes affect how users interact with the project, update the README.md.

### Add Comments

- Add JSDoc comments to public functions
- Explain complex logic
- Document edge cases

### Update CHANGELOG

Add an entry to CHANGELOG.md under the "Unreleased" section:

```markdown
## Unreleased

### Added
- New voice agent feature with enhanced tool calling

### Fixed
- Bug in contact creation validation

### Changed
- Updated authentication flow for SSO
```

---

## Reporting Issues

### Before Creating an Issue

- Search existing issues to avoid duplicates
- Check documentation and FAQs
- Try the latest version

### Creating an Issue

Use the issue templates provided:
- **Bug Report**: For reporting bugs
- **Feature Request**: For suggesting new features
- **Documentation**: For documentation improvements

### Bug Report Template

```markdown
### Description
Clear description of the bug.

### Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

### Expected Behavior
What should happen.

### Actual Behavior
What actually happens.

### Environment
- Node.js version:
- OS:
- Branch:

### Screenshots
If applicable, add screenshots.

### Logs
Include relevant error logs.
```

---

## Review Process

### What Reviewers Look For

- ✅ Code quality and standards
- ✅ Test coverage
- ✅ Documentation
- ✅ Performance implications
- ✅ Security concerns
- ✅ Breaking changes

### Responding to Reviews

- Thank reviewers for feedback
- Ask for clarification if needed
- Make requested changes
- Re-request review after updates
- Don't take criticism personally

---

## Recognition

We value all contributions! Contributors will be:
- Added to CONTRIBUTORS.md
- Mentioned in release notes
- Recognized in project documentation

---

## Questions?

- 📧 Email: support@letshab.com
- 💬 GitHub Discussions
- 🐛 GitHub Issues

---

## License

By contributing to LetsHab.com, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to LetsHab.com! 🎉

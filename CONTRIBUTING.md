# Contribution Guide for FixConnect

Thank you for your interest in contributing to FixConnect! This document provides a set of guidelines for contributing. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

By participating, you are expected to uphold this code. Please report unacceptable behavior to the maintainers.

- Be respectful and inclusive.
- Exercise consideration and respect in your speech and actions.
- Refrain from demeaning, discriminatory, or harassing behavior.

## How Can I Contribute?

### Reporting Bugs

1.  **Check if the bug has already been reported** in the [GitHub Issues](https://github.com/Danielchinasa/FixConnect/issues).
2.  If you can't find an existing issue, [open a new one](https://github.com/Danielchinasa/FixConnect/issues/new).
3.  Use the **Bug Report** template and provide as much detail as possible:
    - **Clear Description:** What happened? What did you expect to happen?
    - **Steps to Reproduce:** A step-by-step list of how to make the bug occur.
    - **Screenshots/Videos:** If applicable.
    - **Environment:** OS, Device, Browser/App Version, etc.

### Suggesting Enhancements

1.  Check the [Issues](https://github.com/Danielchinasa/FixConnect/issues) and [Project Roadmap](https://github.com/Danielchinasa/FixConnect/projects/1) to see if it's already being discussed.
2.  Open a new issue and use the **Feature Request** template.
3.  Provide a clear, detailed explanation of the feature and why it would be beneficial.
4.  Include any mockups, designs, or links to similar implementations if possible.

### Your First Code Contribution

Look for issues labeled `good first issue` or `help wanted`. These are typically well-scoped and perfect for new contributors.

### Pull Request Process

This is the golden rule for how PRs should be merged.

1.  **Fork the Repository:** Click the "Fork" button at the top right of the repo page.
2.  **Create a Feature Branch:** In your forked repo.
    ```bash
    git checkout -b feature/AmazingFeature
    ```
3.  **Commit Your Changes:** Write clear, concise commit messages.
    ```bash
    git commit -m 'feat: Add amazing feature'
    ```
4.  **Push to Your Fork:**
    ```bash
    git push origin feature/AmazingFeature
    ```
5.  **Open a Pull Request:**
    - Go to the _original_ FixConnect repository.
    - You should see a prompt to open a PR from your forked branch.
    - **Fill out the PR template completely.**
    - Ensure your PR description clearly describes the problem and solution. Include relevant issue numbers (e.g., `Fixes #123`).
    - **Link your PR to the relevant issue.**

### Code Review & Merge Process (For Maintainers/You)

1.  **Automated Checks:** Ensure all CI/CD checks (like tests, linters) pass.
2.  **Review:** You (the owner) and other potential maintainers will review the code.
    - Check for code quality, adherence to project standards, and functionality.
    - Provide constructive feedback. Request changes if necessary.
3.  **Squash and Merge:** Once approved, **use the "Squash and Merge"** option for merging.
    - **Why?** This consolidates all commits from the feature branch into a single, clean commit in the `main` branch. It keeps the project history linear, clean, and easy to debug.
4.  **Delete the branch** (both the contributor's and the one on the origin, if it was pushed).

### Development Setup

_To be done soon_

### Style Guide

- Follow the language-specific style guides (Dart/Flutter, Swift, Kotlin, etc.).
- We will use linters and formatters (e.g., `flutter format`, `ESLint`, `Prettier`) to maintain consistency. Configuration files for these should be in the repo.

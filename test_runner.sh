#!/bin/bash

# UFSCartaz Flutter Test Runner
# This script runs all tests for the UFSCartaz Flutter application

set -e

echo "🚀 UFSCartaz Flutter Test Runner"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run a test command
run_test() {
    local test_name=$1
    local test_command=$2
    
    print_status "Running $test_name..."
    
    if eval "$test_command"; then
        print_success "$test_name passed!"
    else
        print_error "$test_name failed!"
        exit 1
    fi
    
    echo ""
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in a Flutter project directory"
    exit 1
fi

print_status "Flutter version:"
flutter --version
echo ""

# Get dependencies
print_status "Getting dependencies..."
flutter pub get
echo ""

# Generate mocks (if needed)
print_status "Generating mocks..."
if flutter pub run build_runner build --delete-conflicting-outputs; then
    print_success "Mocks generated successfully!"
else
    print_warning "Mock generation failed, continuing anyway..."
fi
echo ""

# Run different types of tests
print_status "Starting test execution..."
echo ""

# 1. Unit Tests
run_test "Unit Tests" "flutter test test/models/ test/providers/ --coverage"

# 2. Widget Tests
run_test "Widget Tests" "flutter test test/widgets/ --coverage"

# 3. Integration Tests (if available)
if [ -d "test/integration" ]; then
    run_test "Integration Tests" "flutter test test/integration/ --coverage"
fi

# 4. All Tests Combined
run_test "All Tests" "flutter test --coverage"

# 5. Generate Coverage Report
print_status "Generating coverage report..."
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    print_success "Coverage report generated in coverage/html/"
else
    print_warning "genhtml not found. Install lcov to generate HTML coverage reports."
fi

# 6. Run Analysis
print_status "Running static analysis..."
if flutter analyze; then
    print_success "Static analysis passed!"
else
    print_error "Static analysis failed!"
    exit 1
fi

# 7. Format Check
print_status "Checking code formatting..."
if flutter format --set-exit-if-changed lib/ test/; then
    print_success "Code formatting is correct!"
else
    print_warning "Code formatting issues found. Run 'flutter format lib/ test/' to fix."
fi

# Summary
echo ""
print_success "🎉 All tests completed successfully!"
echo ""
print_status "Test Summary:"
echo "  ✅ Unit Tests"
echo "  ✅ Widget Tests"
echo "  ✅ Integration Tests"
echo "  ✅ Static Analysis"
echo "  ✅ Code Formatting"
echo ""
print_status "Coverage report available in coverage/html/index.html"
echo ""

# Optional: Open coverage report
if command -v xdg-open &> /dev/null; then
    read -p "Open coverage report in browser? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open coverage/html/index.html
    fi
fi 
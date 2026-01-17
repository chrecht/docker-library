#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PHP_MAJOR_VERSION=""
PHP_OS_CODENAME="trixie"
REGISTRY="ghcr.io"
REPOSITORY=""
PUSH=false
BUILD_MULTIARCH=false
VARIANTS=("apache" "cli")
ARCHS=("amd64" "arm64")

# Function to print colored output
print_info() {
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

# Function to show usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Build PHP Docker images similar to GitHub Actions workflow.

OPTIONS:
    -v, --version VERSION       PHP major version (e.g., 8.5, 8.4, 8.3)
    -o, --os-codename CODENAME  OS codename (default: trixie)
    -r, --repository REPO       Repository name (e.g., username/repo)
    -p, --push                  Push images to registry
    -m, --multiarch             Build and create multiarch manifests
    --variant VARIANT           Build specific variant (apache, cli, frankenphp)
    --arch ARCH                 Build specific architecture (amd64, arm64)
    -h, --help                  Show this help message

EXAMPLES:
    # Build all variants and architectures for PHP 8.5 (local only)
    $0 -v 8.5 -r username/repo

    # Build and push all variants for PHP 8.4
    $0 -v 8.4 -r username/repo --push

    # Build only apache variant for amd64
    $0 -v 8.5 -r username/repo --variant apache --arch amd64

    # Build all and create multiarch manifests
    $0 -v 8.5 -r username/repo --push --multiarch

EOF
    exit 1
}

# Parse command line arguments
SPECIFIC_VARIANT=""
SPECIFIC_ARCH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            PHP_MAJOR_VERSION="$2"
            shift 2
            ;;
        -o|--os-codename)
            PHP_OS_CODENAME="$2"
            shift 2
            ;;
        -r|--repository)
            REPOSITORY="$2"
            shift 2
            ;;
        -p|--push)
            PUSH=true
            shift
            ;;
        -m|--multiarch)
            BUILD_MULTIARCH=true
            shift
            ;;
        --variant)
            SPECIFIC_VARIANT="$2"
            shift 2
            ;;
        --arch)
            SPECIFIC_ARCH="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required parameters
if [[ -z "$PHP_MAJOR_VERSION" ]]; then
    print_error "PHP version is required"
    usage
fi

if [[ -z "$REPOSITORY" && "$PUSH" == true ]]; then
    print_error "Repository is required when pushing images"
    usage
fi

# Filter variants and architectures if specific ones are requested
if [[ -n "$SPECIFIC_VARIANT" ]]; then
    VARIANTS=("$SPECIFIC_VARIANT")
fi

if [[ -n "$SPECIFIC_ARCH" ]]; then
    ARCHS=("$SPECIFIC_ARCH")
fi

print_info "Starting PHP $PHP_MAJOR_VERSION build process"
print_info "OS Codename: $PHP_OS_CODENAME"
print_info "Variants: ${VARIANTS[*]}"
print_info "Architectures: ${ARCHS[*]}"
print_info "Push: $PUSH"
print_info "Multiarch: $BUILD_MULTIARCH"

# Step 1: Get latest version from Docker Hub
print_info "Fetching latest PHP version from Docker Hub..."

get_latest_version() {
    local variant=$1
    local latest=$(curl -s "https://hub.docker.com/v2/repositories/library/php/tags?page_size=100&name=${PHP_MAJOR_VERSION}." | \
        jq -r '.results|.[]|.name' | \
        grep -E "^${PHP_MAJOR_VERSION}\.[0-9]+-${variant}-${PHP_OS_CODENAME}$" | \
        sort -V | tail -1)
    
    local ver_full=$(echo $latest | sed -En "s/^([0-9]+\.[0-9]+\.[0-9]+)-${variant}-${PHP_OS_CODENAME}/\1/p")
    echo "$ver_full"
}

# Get version from first variant
VERSION=$(get_latest_version "${VARIANTS[0]}")

if [[ -z "$VERSION" ]]; then
    print_error "Could not determine PHP version from Docker Hub"
    exit 1
fi

MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3)

print_success "Latest version: $VERSION (Major: $MAJOR, Minor: $MINOR, Patch: $PATCH)"

# Step 2: Build images for each variant and architecture
for variant in "${VARIANTS[@]}"; do
    for arch in "${ARCHS[@]}"; do
        
        print_info "Building $variant for $arch..."
        
        # Determine platform
        if [[ "$arch" == "amd64" ]]; then
            platform="linux/amd64"
        elif [[ "$arch" == "arm64" ]]; then
            platform="linux/arm64"
        else
            print_error "Unknown architecture: $arch"
            continue
        fi
        
        # Set context and dockerfile paths
        context="./php/${PHP_MAJOR_VERSION}/${variant}"
        dockerfile="${context}/Dockerfile"
        
        # Check if Dockerfile exists
        if [[ ! -f "$dockerfile" ]]; then
            print_warning "Dockerfile not found: $dockerfile - skipping"
            continue
        fi
        
        # Build image tag
        if [[ -n "$REPOSITORY" ]]; then
            image_tag="${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}-${arch}"
        else
            image_tag="php:${MAJOR}.${MINOR}.${PATCH}-${variant}-${arch}"
        fi
        
        # Build command
        build_cmd="docker buildx build"
        build_cmd+=" --platform=${platform}"
        build_cmd+=" --tag=${image_tag}"
        build_cmd+=" --file=${dockerfile}"
        
        if [[ "$PUSH" == true ]]; then
            build_cmd+=" --push"
        else
            build_cmd+=" --load"
        fi
        
        build_cmd+=" ${context}"
        
        print_info "Executing: $build_cmd"
        
        if eval "$build_cmd"; then
            print_success "Built $image_tag"
        else
            print_error "Failed to build $image_tag"
            exit 1
        fi
    done
done

# Step 3: Create multiarch manifests if requested
if [[ "$BUILD_MULTIARCH" == true && "$PUSH" == true ]]; then
    print_info "Creating multiarch manifests..."
    
    for variant in "${VARIANTS[@]}"; do
        
        print_info "Creating manifest for $variant..."
        
        # Pull individual arch images first
        for arch in "${ARCHS[@]}"; do
            if [[ "$arch" == "amd64" ]]; then
                platform="linux/amd64"
            elif [[ "$arch" == "arm64" ]]; then
                platform="linux/arm64"
            fi
            
            image_tag="${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}-${arch}"
            print_info "Pulling $image_tag..."
            docker pull --platform=${platform} "$image_tag"
        done
        
        # Create multiarch manifest
        manifest_tags=(
            "${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}-${variant}"
            "${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}"
        )
        
        source_images=()
        for arch in "${ARCHS[@]}"; do
            source_images+=("${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}-${arch}")
        done
        
        # Build imagetools create command
        manifest_cmd="docker buildx imagetools create"
        for tag in "${manifest_tags[@]}"; do
            manifest_cmd+=" -t ${tag}"
        done
        for img in "${source_images[@]}"; do
            manifest_cmd+=" ${img}"
        done
        
        print_info "Executing: $manifest_cmd"
        
        if eval "$manifest_cmd"; then
            print_success "Created multiarch manifest for $variant"
            for tag in "${manifest_tags[@]}"; do
                print_success "  - $tag"
            done
        else
            print_error "Failed to create multiarch manifest for $variant"
            exit 1
        fi
    done
fi

print_success "Build process completed successfully!"

# Summary
echo ""
print_info "=== Build Summary ==="
print_info "Version: $VERSION"
print_info "Variants: ${VARIANTS[*]}"
print_info "Architectures: ${ARCHS[*]}"

if [[ -n "$REPOSITORY" ]]; then
    echo ""
    print_info "=== Built Images ==="
    for variant in "${VARIANTS[@]}"; do
        for arch in "${ARCHS[@]}"; do
            echo "  ${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}-${arch}"
        done
    done
    
    if [[ "$BUILD_MULTIARCH" == true && "$PUSH" == true ]]; then
        echo ""
        print_info "=== Multiarch Manifests ==="
        for variant in "${VARIANTS[@]}"; do
            echo "  ${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}-${variant}"
            echo "  ${REGISTRY}/${REPOSITORY}/php:${MAJOR}.${MINOR}.${PATCH}-${variant}"
        done
    fi
fi

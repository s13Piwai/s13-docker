# S13 Training Camps

A self-contained student training website that runs as one Docker container.

## Single-container architecture

The `app` container provides everything:

- Responsive HTML, CSS, and JavaScript website
- Course catalog API
- Student registration and login API
- Enrollment API
- File-based demo persistence through the `app-data` Docker volume

The application uses only the Node.js standard library and has no package dependencies. CI builds the image from the root `Dockerfile`; local builds use the `latest` tag.

## Tools used

- HTML5, CSS3, and vanilla JavaScript
- Node.js 22
- Docker and Docker Compose
- GitHub Actions
- Git and curl

## Run

```bash
docker build -t s13-training-camps:latest .
docker volume create s13-training-camps-data
docker run -d --name s13-training-camps --restart unless-stopped -p 8080:8080 -v s13-training-camps-data:/data s13-training-camps:latest
```

Open <http://localhost:8080>.

## Verify

```bash
docker ps --filter name=s13-training-camps
curl http://localhost:8080/health
curl http://localhost:8080/api/courses
```

## Stop

```bash
docker rm -f s13-training-camps
```

Use `docker volume rm s13-training-camps-data` only when you intentionally want to delete saved demo users and enrollments.

## CI

`.github/workflows/build-s13-training-camps.yml` runs on GitHub's `ubuntu-latest` runner for every branch push and `v*` tag. It builds the image and smoke-tests the health and course APIs. This workflow only verifies the image; it does not deploy the application. No repository secrets are required.

`.github/workflows/publish-ghcr.yml` builds and smoke-tests the image, then publishes it to `ghcr.io/s13piwai/s13-docker:<commit-sha>`. Pushes to the default branch also update `latest`. It uses the repository-provided `GITHUB_TOKEN` with `packages: write`; no additional secret is required. New GHCR packages are private by default and can be made public from the package settings.

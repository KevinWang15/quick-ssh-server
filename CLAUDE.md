# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based SSH server project that provides a simple and fast way to set up an SSH server with root login capabilities. The project creates a containerized Ubuntu environment with OpenSSH server pre-configured.

## Key Architecture

- **Single Dockerfile approach**: The entire application is defined in a single Dockerfile that sets up Ubuntu, installs OpenSSH server, and configures it for root access
- **Pre-generated SSH keys**: Uses base64-encoded SSH host keys embedded in the Dockerfile to ensure consistent host fingerprinting across container restarts
- **Runtime password configuration**: Root password is set via environment variable at container startup

## Build and Run Commands

Since this is a Docker-only project with no package.json or build scripts:

### Build the Docker image:
```bash
docker build -t quick-ssh-server .
```

### Run the container:
```bash
docker run -d -p 2222:22 -e PASSWORD=yourpassword quick-ssh-server
```

### Connect to the SSH server:
```bash
ssh root@localhost -p 2222
```

### Use pre-built image:
```bash
docker pull kevinwang15/quick-ssh-server:latest
docker run -d -p 2222:22 -e PASSWORD=yourpassword kevinwang15/quick-ssh-server:latest
```

## Important Implementation Details

- The container requires the `PASSWORD` environment variable to be set at runtime
- SSH host keys are pre-generated and embedded as base64 in the Dockerfile (lines 13-14)
- The server runs on port 22 inside the container, typically mapped to port 2222 on the host
- Root login is explicitly enabled by modifying `/etc/ssh/sshd_config`
- The SSH daemon runs in foreground mode (`-D` flag) to keep the container running
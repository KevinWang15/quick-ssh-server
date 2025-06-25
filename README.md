# Quick SSH Server

This Docker image provides a simple and fast way to set up an SSH server. The server allows root login with password or SSH key authentication. Pre-generated SSH keys are used to ensure consistent host keys across container restarts.

## Features

- Based on the latest Ubuntu image.
- OpenSSH server pre-installed and configured.
- Root login enabled with password and/or SSH key authentication.
- Root password set via an environment variable.
- SSH key authentication with persistent authorized_keys storage.
- Gateway ports enabled for reverse SSH tunneling.
- Consistent SSH host keys for reliable host fingerprinting.

## Usage

### Using Docker Compose (Recommended)

The easiest way to run the SSH server with persistent SSH key storage:

```sh
# Set password and start
PASSWORD=yoursecurepassword docker-compose up -d

# Or create a .env file with PASSWORD=yoursecurepassword
docker-compose up -d
```

This will:
- Use host networking for better reverse tunneling support
- Mount `./ssh-keys` directory for persistent SSH key storage
- Support both password and SSH key authentication

### Using the Pre-built Image

To get started quickly, you can use the pre-built Docker image available on Docker Hub:

```sh
docker pull kevinwang15/quick-ssh-server:latest
docker run -d -p 2222:22 -e PASSWORD=yourpassword kevinwang15/quick-ssh-server:latest
```

### Build the Docker Image

If you prefer to build the Docker image yourself, run the following command in the directory containing the Dockerfile:

```sh
docker build -t quick-ssh-server .
```

### Run the Docker Container

#### Basic Usage (Password Only)
```sh
docker run -d -p 2222:22 -e PASSWORD=yourpassword quick-ssh-server
```

#### With SSH Key Support
```sh
mkdir -p ssh-keys
docker run -d -p 2222:22 -v ./ssh-keys:/root/.ssh -e PASSWORD=yourpassword quick-ssh-server
```

#### Host Network Mode (for reverse tunneling)
```sh
docker run -d --network host -v ./ssh-keys:/root/.ssh -e PASSWORD=yourpassword -e SSH_PORT=2222 quick-ssh-server
```

### Setting Up SSH Key Authentication

1. **Create the ssh-keys directory:**
   ```sh
   mkdir -p ssh-keys
   ```

2. **Add your public key to authorized_keys:**
   ```sh
   # Copy your public key to authorized_keys
   cp ~/.ssh/id_rsa.pub ssh-keys/authorized_keys
   
   # Or append multiple keys
   cat ~/.ssh/id_rsa.pub >> ssh-keys/authorized_keys
   cat ~/.ssh/id_ed25519.pub >> ssh-keys/authorized_keys
   ```

3. **Set proper permissions:**
   ```sh
   chmod 600 ssh-keys/authorized_keys
   ```

4. **Start the container:**
   ```sh
   docker-compose up -d
   ```

### Connect to the SSH Server

#### Password Authentication
```sh
ssh root@localhost -p 2222
```

#### SSH Key Authentication
```sh
ssh -i ~/.ssh/id_rsa root@localhost -p 2222
```

### Reverse SSH Tunneling

With GatewayPorts enabled, you can create reverse tunnels:

```sh
# Forward remote port 8080 to local port 3000
ssh -R 8080:localhost:3000 root@yourserver -p 2222

# Forward remote port 80 to local port 8000 (accessible from any interface)
ssh -R 0.0.0.0:80:localhost:8000 root@yourserver -p 2222
```

### Environment Variables

- `PASSWORD`: The password for the root user. This variable is required and must be set at runtime.
- `SSH_PORT`: The port SSH server listens on. Defaults to 22, but docker-compose defaults to 2222 to avoid conflicts with host SSH.

## Examples

### Quick Start with Docker Compose
```sh
# Clone or download this repository
git clone <repository-url>
cd quick-ssh-server

# Start with password authentication (uses port 2222 by default)
PASSWORD=mysecurepassword docker-compose up -d

# Connect via password
ssh root@localhost -p 2222

# Or specify custom port
SSH_PORT=2223 PASSWORD=mysecurepassword docker-compose up -d
ssh root@localhost -p 2223
```

### SSH Key Authentication Setup
```sh
# Create ssh-keys directory and add your public key
mkdir -p ssh-keys
cp ~/.ssh/id_rsa.pub ssh-keys/authorized_keys
chmod 600 ssh-keys/authorized_keys

# Start the server
PASSWORD=mysecurepassword docker-compose up -d

# Connect with SSH key
ssh -i ~/.ssh/id_rsa root@localhost -p 2222
```

### Reverse Tunneling Example
```sh
# Start the SSH server
PASSWORD=mysecurepassword docker-compose up -d

# From a remote machine, forward port 8080 to your local web server
ssh -R 8080:localhost:3000 root@your-server-ip -p 2222

# Now port 8080 on your server forwards to port 3000 on the remote machine
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

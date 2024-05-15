# Quick SSH Server

This Docker image provides a simple and fast way to set up an SSH server. The server allows root login with a password specified at runtime. Pre-generated SSH keys are used to ensure consistent host keys across container restarts.

## Features

- Based on the latest Ubuntu image.
- OpenSSH server pre-installed and configured.
- Root login enabled.
- Root password set via an environment variable.
- Consistent SSH host keys for reliable host fingerprinting.

## Usage

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

To run the Docker container, use the following command. Replace `yourpassword` with your desired root password:

```sh
docker run -d -p 2222:22 -e PASSWORD=yourpassword quick-ssh-server
```

### Connect to the SSH Server

You can connect to the SSH server using an SSH client. Use the root user and the password you specified when running the container:

```sh
ssh root@localhost -p 2222
```

### Environment Variables

- `PASSWORD`: The password for the root user. This variable is required and must be set at runtime.

## Example

Using the pre-built image:

```sh
docker pull kevinwang15/quick-ssh-server:latest
docker run -d -p 2222:22 -e PASSWORD=mysecurepassword kevinwang15/quick-ssh-server:latest
ssh root@localhost -p 2222
```

Building and running your own image:

```sh
docker build -t quick-ssh-server .
docker run -d -p 2222:22 -e PASSWORD=mysecurepassword quick-ssh-server
ssh root@localhost -p 2222
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

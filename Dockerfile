# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Install OpenSSH server
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Allow root login and enable gateway ports
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Create .ssh directory for root
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy the pre-generated SSH host keys into the container
RUN echo "LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFNd0FBQUF0emMyZ3RaVwpReU5UVXhPUUFBQUNEMDJYUFpHTjcwZEpuREtQMWlRWWVjSEtnZXdXRktiZ2R0SGRYcStlZ2QwZ0FBQUpoeFp5MVZjV2N0ClZRQUFBQXR6YzJndFpXUXlOVFV4T1FBQUFDRDAyWFBaR043MGRKbkRLUDFpUVllY0hLZ2V3V0ZLYmdkdEhkWHErZWdkMGcKQUFBRUJTV0hRd1JCUDdLRUNQSU1SbXErSjZaSTl1ZWJMbTRiKyt1Y3lJYVc3a1cvVFpjOWtZM3ZSMG1jTW8vV0pCaDV3YwpxQjdCWVVwdUIyMGQxZXI1NkIzU0FBQUFGR0o1ZEdWa1lXNWpaVUJSUnpFNVVUbElWRU0wQVE9PQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K" | base64 -d > /etc/ssh/ssh_host_ed25519_key && \
    echo "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBUWmM5a1kzdlIwbWNNby9XSkJoNXdjcUI3QllVcHVCMjBkMWVyNTZCM1MgYnl0ZWRhbmNlQFFHMTlROUhUQzQK" | base64 -d > /etc/ssh/ssh_host_ed25519_key.pub

# Ensure the SSH keys have the correct permissions
RUN chmod 600 /etc/ssh/ssh_host_ed25519_key && \
    chmod 644 /etc/ssh/ssh_host_ed25519_key.pub


# Expose SSH port
EXPOSE 22

# Set root password and start SSH server in the foreground
CMD ["/bin/bash", "-c", "\
    if [ -z \"$PASSWORD\" ]; then \
        echo 'PASSWORD environment variable is not set.'; \
        exit 1; \
    fi; \
    echo \"root:$PASSWORD\" | chpasswd; \
    /usr/sbin/sshd -D \
"]

# dotoold systemd service

This directory contains systemd service files for running `dotoold` as a daemon. `dotoold` is the daemon component of the `dotool` input simulation tool, which is used by nerd-dictation for the `DOTOOLC` input method.

## What is dotoold?

`dotoold` is a daemon that runs in the background to improve performance when using `dotool` for input simulation. Instead of starting a new `dotool` process for each input command, `dotoold` stays running and `dotoolc` communicates with it through a pipe.

## Prerequisites

Before installing the service, you need to have `dotool` installed on your system:

1. Install `dotool` from the official repository: https://git.sr.ht/~geb/dotool
2. Make sure `dotoold` and `dotoolc` are available in your PATH

## Installation

### Option 1: Automatic installation (recommended)

Run the installation script:

```bash
# For user service (recommended)
./install-dotoold-service.sh

# For system service (run as root)
sudo ./install-dotoold-service.sh
```

### Option 2: Manual installation

#### System service

1. Copy the service file:
   ```bash
   sudo cp dotoold.service /etc/systemd/system/
   ```

2. Set up udev rule for uinput access:
   ```bash
   echo 'KERNEL=="uinput", GROUP="input", MODE="0620"' | sudo tee /etc/udev/rules.d/80-uinput.rules
   ```

3. Add your user to the input group:
   ```bash
   sudo usermod -a -G input $USER
   ```

4. Reload systemd and enable the service:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable dotoold.service
   sudo systemctl start dotoold.service
   ```

#### User service

1. Create the user systemd directory:
   ```bash
   mkdir -p ~/.config/systemd/user
   ```

2. Copy the user service file:
   ```bash
   cp dotoold-user.service ~/.config/systemd/user/dotoold.service
   ```

3. Set up udev rule and add user to input group:
   ```bash
   echo 'KERNEL=="uinput", GROUP="input", MODE="0620"' | sudo tee /etc/udev/rules.d/80-uinput.rules
   sudo usermod -a -G input $USER
   ```

4. Reload systemd and enable the service:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable dotoold.service
   systemctl --user start dotoold.service
   ```

## Usage

After installation, you can:

### Check service status
```bash
# System service
sudo systemctl status dotoold.service

# User service
systemctl --user status dotoold.service
```

### Test the service
```bash
echo 'type hello world' | dotoolc
```

### Use with nerd-dictation
Once the service is running, you can use nerd-dictation with the `DOTOOLC` input method:

```bash
./nerd-dictation begin --simulate-input-tool=DOTOOLC
```

## Troubleshooting

### Service fails to start

1. Check if `dotoold` is in your PATH:
   ```bash
   which dotoold
   ```

2. Check if your user is in the input group:
   ```bash
   groups $USER
   ```

3. Check if udev rule is applied:
   ```bash
   ls -la /dev/uinput
   ```

4. You may need to reboot or log out/in for group changes to take effect.

### Permission denied errors

- Make sure your user is in the `input` group
- Check that the udev rule is properly set up
- Verify that `/dev/uinput` has the correct permissions

## Files

- `dotoold.service` - System service file
- `dotoold-user.service` - User service file  
- `install-dotoold-service.sh` - Installation script
- `README-dotoold-service.md` - This file

## Security Notes

The service files include security settings to restrict what the daemon can access:
- `NoNewPrivileges=true` - Prevents privilege escalation
- `PrivateTmp=true` - Provides private /tmp directory
- `ProtectSystem=strict` - Protects system directories
- `ProtectHome=true` - Protects home directories
- `DevicePolicy=closed` - Restricts device access to only what's explicitly allowed

## Why use dotoold?

Using `dotoold` provides several benefits:
1. **Performance**: Avoids the overhead of starting a new process for each input command
2. **Reliability**: Maintains a persistent connection for input simulation
3. **Efficiency**: Better resource usage when doing frequent input simulation

This is particularly beneficial for speech-to-text applications like nerd-dictation where input simulation happens frequently. 
{
  flake.nixosModules.networking = {...}: {
    /*
    802.1X Enterprise Wi-Fi (eduroam & CU Secure)

    NetworkManager connection profiles for 802.1X networks contain secrets
    (passwords, client certificates, private keys). Declaring these in Nix
    would expose them in the world-readable /nix/store. Without a secrets
    manager like sops-nix or agenix, these profiles must be configured
    imperatively with nmcli.

    The JoinNow (SecureW2) provisioning script places certificates into
    ~/.joinnow, but wpa_supplicant cannot read them there. Its systemd unit
    sets ProtectHome=true and ProtectSystem=strict, which blocks access to
    most of the filesystem. The directory /etc/wpa_supplicant is accessible
    because it is listed in BindPaths=, and the service runs as
    User=wpa_supplicant, so certificates must be owned by that user.

    Note that /var/lib/NetworkManager/certs does not work for the same
    reason; it is not bind-mounted into the sandbox.

    This directory persists across nixos-rebuild but not across fresh
    installs. Client certificates from SecureW2 expire after roughly one
    year and will need to be regenerated.

    To reproduce this setup on a new machine:

    1. Run the JoinNow (SecureW2) provisioning script. This creates the
       NetworkManager profiles and places certificates in ~/.joinnow.

    2. Copy the certificates into a path the sandbox can reach:

         sudo mkdir -p /etc/wpa_supplicant/certs
         sudo cp -r ~/.joinnow/* /etc/wpa_supplicant/certs/
         sudo chown -R wpa_supplicant:wpa_supplicant /etc/wpa_supplicant/certs
         sudo chmod -R 600 /etc/wpa_supplicant/certs
         sudo chmod 700 /etc/wpa_supplicant/certs
         sudo chmod 700 /etc/wpa_supplicant/certs/tls-client-certs

    3. Update each connection profile to point to the new paths. Use sudo
       because nmcli validates the file paths on modify and the certificates
       are only readable by wpa_supplicant:

         sudo nmcli connection modify "<name>" \
           802-1x.ca-cert "/etc/wpa_supplicant/certs/<ca-bundle>.pem"

       For TLS-based profiles (CU Secure), also update 802-1x.client-cert
       and 802-1x.private-key.

    4. Disable MAC address randomization for eduroam, which filters
       connections from unregistered hardware addresses:

         nmcli connection modify "eduroam [<uuid>]" \
           802-11-wireless.cloned-mac-address permanent
    */

    # Enable networking
    networking.networkmanager.enable = true;
    # Specify the Wi-Fi backend used for the device.
    # Currently supported are wpa_supplicant or iwd (experimental).
    # networking.networkmanager.wifi.backend = "iwd";
  };
}

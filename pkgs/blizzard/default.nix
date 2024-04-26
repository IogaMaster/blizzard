{
  lib,
  writeShellApplication,
  stdenv,
  ...
}:
writeShellApplication {
  name = "blizzard";

  text = ''
    # ============================= Functions =============================

    preflight() {
        echo ""
        echo "--- 📋 Pre-flight Checks ---"
        echo ""

        if ! ping "$HOST" -c 1 &> /dev/null
        then
            echo "🚨 $HOST is not reachable!"
            exit 1
        else
            echo "✅ $HOST is reachable!"
        fi

        # Check if root access is possible
        if ! ssh root@"$HOST" "whoami" &> /dev/null
        then
            echo "🚨 Cannot become root on $HOST!"
            exit 1
        else
            echo "✅ Can become root on $HOST! "
        fi


        # Check if nix is installed, if not preform the installation
        if ! ssh root@"$HOST" "command -v nix" &> /dev/null
        then
            echo "⚠️ Nix is not installed!"
            echo "❄️ Installing nix..."
            sh <(curl -L https://nixos.org/nix/install) --daemon --yes
        else
            echo "✅ Nix is installed! "
        fi

        # Check if kexec is supported
        if ! ssh root@"$HOST" "command -v kexec" &> /dev/null
        then
            echo "🚨 kexec is not supported!"
            exit 1
        else
            echo "✅ kexec is supported! "
        fi
    }

    create_kexec() {
        echo ""
        echo "--- ⚙️ Bundle stage two installer into kexec image ---"
        echo ""

        echo "🫙 Building kexec bundle..."
        KEXEC_PATH="$(nix run github:nix-community/nixos-generators -- -f kexec-bundle -c ${./kexec.nix})"
    }

    run_kexec() {
        echo ""
        echo "--- ⚙️ Bundle stage two installer into kexec image ---"
        echo ""

        echo "📡 Copy kexec bundle to $HOST and run..."
        scp "$KEXEC_PATH" root@"$HOST":/kexec
        ssh root@"$HOST" "/kexec"
    }



    # ============================= Main Script =============================

    echo "🌨️ blizzard"
    # FLAKE=$1
    HOST=$2

    preflight
    create_kexec
    run_kexec

    echo ""
    echo "✅ Done, the installation is being preformed on $HOST"
  '';
}

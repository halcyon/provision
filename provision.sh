#!/usr/bin/env zsh

user=smcleod

clone_repos() {
sudo -iu ${user} zsh <<EOF
  if [[ ! -d ~/dotfiles ]]
  then
    git clone git@github.com:halcyon/dotfiles.git
    cd dotfiles; ./stow.sh; cd ..
  fi

  if [[ ! -d ~/dotfiles-private ]]
  then
    git clone git@bitbucket.org:halcyonblue/dotfiles-private.git
    cd dotfiles-private; ./stow.sh; cd ..
  fi


  if [[ ! -d ~/.oh-my-zsh ]]
  then
      git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
  fi

  mkdir -p projects
  if [[ ! -d ~/projects/recipes ]]
  then
    cd projects
    git clone git@gitlab.com:halcyonblue/recipes.git
    cd ..
  fi

  if [[ ! -d ~/projects/arch-vm ]]
  then
    cd projects
    git clone git@github.com:halcyon/arch-vm.git
    cd ..
  fi

  if [[ ! -d ~/projects/org ]]
  then
    cd projects
    git clone git@github.com:halcyon/org.git
    cd ..
  fi
EOF
}

install_quicklisp() {
if [[ ! -d /home/${user}/quicklisp ]]
then
sudo -u ${user} zsh <<EOF
  curl -O https://beta.quicklisp.org/quicklisp.lisp
  sbcl --load install-quicklisp.lisp
EOF
fi
}

install_stumpwm() {
if [[ ! -f /usr/local/bin/stumpwm ]]
then
sudo -iu ${user} zsh <<EOF
  git clone https://github.com/stumpwm/stumpwm.git
  cd stumpwm
  autoconf
  ./configure
  make
EOF
  cd /home/${user}/stumpwm
  make install
  cd
  rm -rf /home/${user}/stumpwm
fi
}

install_packages() {
    typeset -U shell
    shell=("autojump" "tmux" "stow")

    typeset -U utilities
    utilities=("pass" "the_silver_searcher" "openconnect" "unzip" "emacs-nox"
               "git" "jdk8-openjdk" "rclone" "sbcl")

    typeset -U bluetooth
    utilities=("bluez" "bluez-utils")

    typeset -U xorg
    xorg=("xf86-input-synaptics" "xorg-server" "xorg-server-utils" "xorg-apps"
          "xorg-xinit" "xclip" "konsole" "ttf-symbola" "ttf-ubuntu-font-family"
          "noto-fonts" "flashplugin" "firefox" "calibre")

    typeset -U aur
    aur=("aur-git" "powerpill" "leiningen-standalone" "tmate" "totp-cli" "dropbox"
         "dropbox-cli" "slack-desktop" "kiwix-bin" "ttf-fira-code")

    aura --noconfirm --needed -S ${shell}
    aura --noconfirm --needed -S ${utilities}
    aura --noconfirm --needed -S ${xorg}
    aura --noconfirm --needed -A ${aur}
}

install_packages
clone_repos
install_quicklisp
install_stumpwm

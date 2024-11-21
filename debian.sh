USRDIR=/home/henry
sudo apt-get update
sudo apt-get install -y -q net-tools openssh-client xclip gcc
if [ ! -d $USRDIR/.ssh ]; then
  mkdir $USRDIR/.ssh;
fi
cd $USRDIR/.ssh
KEYFILENAME="id_rsa"
if [ ! -f $KEYFILENAME ]; then
  echo $KEYFILENAME
  ssh-keygen -N "" -f $KEYFILENAME
  eval `ssh-agent`
  ssh-add $KEYFILENAME
  cat id_rsa.pub
  cat id_rsa.pub | xclip -sel clip
  echo 'Public key copied to clipboard. Paste into GitHub.'
  read -n 1 -s
fi
BINDIR=/usr/local
sudo apt-get install -y -q wget git curl
if [ ! -f $BINDIR/bin/nvim ]; then
  wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz && 
    tar xzvf nvim-linux64.tar.gz && 
    sudo mv nvim-linux64 $BINDIR/ && 
    sudo ln -s $BINDIR/nvim-linux64/bin/nvim $BINDIR/bin/nvim
      rm nvim-linux64.tar.gz
      mkdir -p $USRDIR/.local/share/nvim/site/autoload
      curl -fLo $USRDIR/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -d $USRDIR/.config ]; then
  mkdir $USRDIR/.config && cd $USRDIR/.config
  git clone ssh://git@github.com/hcrans/nvim.git
  nvim +PlugInstall
fi
if [ ! -d $USRDIR/repos ]; then
  mkdir $USRDIR/repos && cd $USRDIR/repos
  git clone ssh://git@github.com/hcrans/meantToLive
  git clone ssh://git@github.com/hcrans/theSound
  git clone ssh://git@github.com/hcrans/beautifulLetdown
fi

#THIS ISN'T NEEDED WITH WSL
# sudo apt-get install -y -q fontconfig wget libarchive-tools
# if [ ! -f $USRDIR/.local/share/fonts/HackNerdFont-Regular.ttf ]; then
#   mkdir $USRDIR/.local/share/fonts
#   wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip | \
#   bsdtar -xvf- -C $USRDIR/.local/share/fonts && \
#   fc-cache -fv
# fi

#sudo apt-get install -y -q fish
#sudo apt-get install -y -q fzf 

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install -g node
npm install -g @go-task/cli

cd $USRDIR
source ~/.bashrc

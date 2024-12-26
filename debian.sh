sudo apt-get update
sudo apt-get install -y -q net-tools openssh-client xclip gcc iputils-ping ripgrep unzip fd-find make
if [ ! -d $HOME/.ssh ]; then
  mkdir $HOME/.ssh;
fi

sudo apt-get install -y -q wget git curl
if [ ! -d $HOME/.oh-my-bash ]; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
fi

if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  source ~/.bashrc
fi
nvm install node
npm install -g @go-task/cli

cd $HOME/.ssh
KEYFILENAME="id_rsa"
if [ ! -f $KEYFILENAME ]; then
  echo $KEYFILENAME
  # ssh-keygen -N "" -f $KEYFILENAME
  eval `ssh-agent`
  ssh-add $KEYFILENAME
  # cat id_rsa.pub
  # cat id_rsa.pub | xclip -sel clip
  # echo 'Public key copied to clipboard. Paste into GitHub.'
  # read -n 1 -s
fi
BINDIR=/usr/local
if [ ! -f $BINDIR/bin/nvim ]; then
  wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz && 
    tar xzvf nvim-linux64.tar.gz && 
    sudo mv nvim-linux64 $BINDIR/ && 
    sudo ln -s $BINDIR/nvim-linux64/bin/nvim $BINDIR/bin/nvim
      rm nvim-linux64.tar.gz
      mkdir -p $HOME/.local/share/nvim/site/autoload
      curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -d $HOME/.config ]; then
  mkdir $HOME/.config && cd $HOME/.config
  git config --global user.email "henry@gmail.com"
  git config --global user.name "henry@gmail.com"
  git clone ssh://git@github.com/hcrans/nvim.git
  nvim +PlugInstall
fi
if [ ! -d $HOME/repos ]; then
  mkdir $HOME/repos && cd $HOME/repos
  git clone ssh://git@github.com/hcrans/meantToLive
  git clone ssh://git@github.com/hcrans/theSound
  git clone ssh://git@github.com/hcrans/beautifulLetdown
  git clone ssh://git@github.com/hcrans/docker
fi

#sudo apt-get install -y -q tmux

#THIS ISN'T NEEDED WITH WSL
# sudo apt-get install -y -q fontconfig wget libarchive-tools
# if [ ! -f $HOME/.local/share/fonts/HackNerdFont-Regular.ttf ]; then
#   mkdir $HOME/.local/share/fonts
#   wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip | \
#   bsdtar -xvf- -C $HOME/.local/share/fonts && \
#   fc-cache -fv
# fi

#sudo apt-get install -y -q fish
#sudo apt-get install -y -q fzf 

bash -c "$(curl -fsSL https://get.docker.com get-docker.sh)" --unattended

cd $HOME/repos/theSound
echo -n 'Enter db password: '
read -s db_password
echo -n SQL_PASSWORD=$db_password > .env
task installPsql
task createDb
task createAllTables

cd $HOME/repos/beautifulLetdown
task npmI
mv ../../apiEnv.local .env.local

cd $HOME/repos/meantToLive
task npmI

cd $HOME/repos
source ~/.bashrc

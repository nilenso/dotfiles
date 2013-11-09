bak_timestamp = $(shell date +%s)
bak_dir = $(HOME)/.dotfiles.bak/$(bak_timestamp)

backup_and_link = \
	if [ -f $(HOME)/$(2) -o -d $(HOME)/$(2) -o -L $(HOME)/$(2) ] ; then \
		cp -RLH $(HOME)/$(2) $(bak_dir)/$(2); \
		rm -rf $(HOME)/$(2); \
	fi; \
	ln -s `pwd`/$(1) $(HOME)/$(2);

install: configure

configure: configure-ack configure-bash configure-zsh configure-gem configure-git configure-irb configure-pry configure-tmux configure-vim

create-backup: 
	mkdir -p $(bak_dir)

configure-ack: create-backup
	$(call backup_and_link,ack/ackrc,.ackrc)

configure-bash: create-backup
	$(call backup_and_link,bash/bashrc,.bashrc)

configure-gem: create-backup
	$(call backup_and_link,gem/gemrc,.gemrc)

configure-git: create-backup
	$(call backup_and_link,git/gitignore,.gitignore)
	$(call backup_and_link,git/gitconfig.withoutuser,.gitconfig.withoutuser)

configure-irb: create-backup
	$(call backup_and_link,irb/irbrc,.irbrc)

configure-pry: create-backup
	$(call backup_and_link,pry/pryrc,.pryrc)

configure-rbenv: update-submodules create-backup
	$(call backup_and_link,rbenv/rbenv,.rbenv)
	echo 'export PATH="$(HOME)/.rbenv/bin:$(PATH)"' >> ~/.bashrc
	echo 'export PATH="$(HOME)/.rbenv/bin:$(PATH)"' >> ~/.zshrc
	echo 'eval "$$(rbenv init -)"' >> ~/.bashrc
	echo 'eval "$$(rbenv init -)"' >> ~/.zshrc

configure-tmux: create-backup
	$(call backup_and_link,tmux/tmux.conf,.tmux.conf)

configure-vim: create-backup
	$(call backup_and_link,vim/vimrc,.vimrc)

# We don't symlink the oh-my-zsh submodule as oh-my-zsh auto-updates itself.
configure-zsh: create-backup
	if [ ! -d $(HOME)/.oh-my-zsh ]; then \
		cp -r `pwd`/zsh/oh-my-zsh $(HOME)/.oh-my-zsh; \
	fi;
	$(call backup_and_link,zsh/zshrc,.zshrc)

update-submodules:
	git submodule init
	git submodule update

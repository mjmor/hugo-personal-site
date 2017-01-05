+++
date = "2016-12-12T15:07:25-05:00"
title = "ricing arch"
categories = [
  "technology",
]
series = [
  "ricing-arch",
]
thumbnail = "assets/arch-rice-mono.jpg"
postname = "Ricing Arch Linux - Part 1 - Window Manager"
tags = [
  "rice", "arch-linux"
]

+++

So. You've decided to make the switch to Arch Linux and you've got your Xorg 
display configured with a little help from the 
[Arch wiki][1], 
but this distro doesn't look **anything** like you've seen advertised!?! Or 
maybe it does and all you were expecting were a few tty's... *who am I to 
judge*? Anyhow, I'm here to talk about making that barebone system into 
something you can look at in admiration. I'm here to talk about ricing. 

This will be the first part of a series focusing on ricing Arch Linux, and as 
the title implies, this part is about window managers. In this tutorial series, 
I'll try to demystify the beutification of a Unix-based OS. 

### What is Ricing?

From the 
[/r/unixporn wiki][2]:

> 'Rice' is a word that is commonly used to refer to making visual improvements 
> and customizations on one's desktop.

This is most commonly done on Unix platforms such as Linux and Mac OS / OSX 
because these operating systems are capable of using user-selected components 
of an operating system, which brings us to the next topic.

### Visual Components of an Operating System

An operating system has many visual components but the following are among the 
most basic and notable and are usually the subject of ricing:

+ Window Manager
+ Terminal Emulator (ok, ok, this isn't REALLY necessary)
+ Status Bar
+ Widget / Window Theme & Other Tidbits (Composition Manager, Application 
Launcher, Screen Saver, Fonts, etc.)

I've listed these elements in the order in which I'll discuss them in my posts, 
and I'll touch on each of them here briefly. 

A **window manager** configures the layout, borders, and actions of 
windows displayed on the screen. This includes, but is not limited to, where a 
window is placed when opened (relative to other windows as well as which 
virtual workspace it is placed on), the color and thickness of a window's
border, which controls are used to close, enlarge, and shrink the window, as 
well as which interfaces the user can use to control the windows (keyboard 
shortcuts, mouse gestures, etc.) Some of my favorite examples of window 
managers are [i3 Window Manager][3] and [XMonad Window Manager][4].

A **terminal emulator** is a progam providing the user with an interface through 
which to communicate with the computer. This is typically done with text 
input / output. The terminal also provides a home for the user's shell of 
choice (be it bash, zsh, fish, or another). The terminal emulator can be 
customized in many ways including changing the font style, the shell prompt, 
the color scheme, and other elements of the terminal's appearance. Some 
examples of terminal emulators are [rxvt][5] and [xterm][6].

A **status bar** is where system information is diplayed: which windows are 
open, which virtual desktops are active, current time and date, network status, 
etc. Like the terminal emulator, a status bar can be configured to use custom 
font styles and special color schemes as well as display whichever system 
information the user deems fit. Some examples of status bars are [i3bar][7] 
(which is used in conjuction with the i3 window manager) and [xmobar][8] 
(which can be used as a standalone status bar or in conjuction with xmonad 
window manager). 

### Configuring a Window Manager (i3)

Configuring a window manager is often the first step to ricing a system. I've 
used a few different window managers, and I find i3 to be the easiest to 
approach (unless you're familiar with the Haskell programming language, in 
which case, XMonad may be your cup of tea).

Setting up a window manager consists of three main steps:

1. Download and install the package
2. Start the window manager
3. Tweak the hell out of the settings until you're satisfied

The third step is the most interesting but for completeness, I'll include the 
first two steps as well.

#### Downloading and Installing i3-gaps

The source code for i3 gaps (an unofficial but commonly used fork of the 
original i3 window manager) can be found [here][9]. Since I'll be using Arch 
Linux, I'll download and install i3-gaps using the Arch User Repository (AUR), 
but if you're using something other than Arch, you can find installation 
instructions for your package manager of choice (or via manual installation) 
[here][10]. I'll use yaourt to download and install i3-gaps like so:
```
yaourt i3-gaps-git
```
yaourt should prompt you to install some basic dependencies which include 
i3bar and i3status. You should accept the recommendation because i3bar and 
i3status will provide you with a nice initial status bar (albeit one with 
default configurations) which you can modify later. 

#### Starting i3-gaps on Login

The next step is to configure your system to start *i3* 
window manager with the X Window System. This can be done using a program 
called *xinit*. *xinit* is mainly used to execute desktop environments, window 
managers, and other programs when starting the X Server (including the X 
Window System) at the beginning of a user's XSession (typically after login). 
*xinit* is included in the *xorg-xinit* package and can be 
installed with the following command on Arch Linux:
```
sudo pacman -S xorg-xinit
```

The *xinit* program uses a shell script to determine which window manager 
(and, possibly, other auxillery programs) to execute after starting the X 
Window System. A default shell script used by *xinit* can be found at 
`/etc/X11/xinit/xinitrc`. We'll examine the default shell script to 
understand what is going on under-the-hood, then we'll make a copy of the 
script and tailor it to our liking. Here is the default shell script:
```
/etc/X11/xinit/xinitrc
------------------------------------------------------------------------------
#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
```
We'll break the script down into two pieces. The first piece: 
```
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
```
This portion of the shell script checks to see if there are any system-wide or 
user-specific configuration files for X resources (configuration parameters 
used by X client applications). If such configuration files exist, the
configurations are merged into the existing configurations. The shell script 
also checks to see if there are any system-wide or user-specific xmodmap 
configuration files. These files are used by the xmodmap program to modify 
key mappings and pointer button mappings. ***You don't have to worry about these 
configuration files just yet, they will be covered in more depth in the post 
regarding customization of the terminal emulator***

The second piece:
```
# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
```
This portion of the shell script is responsible for starting all programs 
needed after the X Window System is started. It checks if any executable shell 
scripts exist in `/etc/X11/xinit/xinitrc.d/` and if so, it will execute those 
scripts. It then launches *twm* (tabbed window manager), xclock, and three 
instances of xterm. 

***It is important to note***: the last instance of xterm 
invoked is done so using the exec command rather than launching it in the 
background (using &) like the others. The X Window System is a group of
child processes whose parent is the *xinit* program. Therefore, if the *xinit* 
program exits, so will the X Window System (bye, bye, GUI). By calling exec on 
the last instance of xterm, the shell script's process will be passed to xterm 
instead and the X Window System will not exit unless the xterm process 
is killed. 

Now that we understand what *xinit* is doing under-the-hood, we can begin to 
alter the *xinitrc* shell script to do what we want. Namely, we'd like to 
launch the i3-gaps window manager instead of *twm*. 

First, we'll copy the default config to the user-specific configuration 
directory, `~/.xinitrc`. 

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
```

Then we'll remove the last 5 lines of the default configuration and add 
`exec i3-gaps` instead, like so:

```
/etc/X11/xinit/xinitrc
------------------------------------------------------------------------------
#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec i3-gaps
```

***Note that we've now replaced the*** `exec xterm` ***with*** `exec i3-gaps`, 
***therefore, if the i3-gaps window manager exits, then so will the X Window 
System.***

If you've done everything up to this step, when you log into a tty after 
booting Arch, you should be greeted by an X Window System running the i3-gaps 
window manager, i3bar (shows virtual desktops, is interactive), and i3status 
(shows system information)! Hurray! 

#### Tweaking i3-gaps Config

The i3-gaps window manager (if being run for the first 
time) will prompt you with a brief configuration wizard asking you which key 
you'd like to use as your Mod key. The Mod key is just a special key used for 
key bindings. Many people set it to the Windows key or the Command key (Apple).

Something you might want to know right away is that the default key binding 
for launching a terminal in i3 is Mod+Enter.

The configuration wizard will also copy the global configuration file 
from `/etc/i3/config` to `~/.config/i3/config` and this is where all your 
user-specific changes will be made. 

We can see the file here:
```
~/.config/i3/config
-------------------------------------------------------------------------------
# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:monospace 8

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# use these keys for focus, movement, and resize directions when reaching for
# the arrows is not convenient
set $up l
set $down k
set $left j
set $right semicolon

# use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec i3-sensible-terminal

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
bindsym $mod+d exec dmenu_run
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym $left       resize shrink width 10 px or 10 ppt
        bindsym $down       resize grow height 10 px or 10 ppt
        bindsym $up         resize shrink height 10 px or 10 ppt
        bindsym $right      resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
        status_command i3status
}
```

The i3 configuration file and commands are very readable and the default 
configuration generated has some useful comments. Some immediate things to 
point out are the `bindsym` and `set` commands. 

The `bindsym` command binds a particular key combination to an i3 command. One 
example is `bindsym $mod+r mode "resize"` which binds the Mod+r key 
combination to resize mode. In resize mode, you can resize the current 
window in focus using `j` (shrink width), `k` (grow height), `l` (shrink height), 
or `;` (grow width). You can then exit resize mode with the escape key. 

The `set` command sets i3 variables to particular values. These values can be 
other i3 variables, i3 key codes, or literal values. An example is `set $left 
j` which 
sets the variable `left` to the `j` key. As you may have noticed, i3 variables 
are always prefixed with the `$` symbol, even when being set. Similar to the 
example you could say `set $ws1 "Workspace #1"` in order to set the variable 
`ws1` to the literal `"Workspace #1"`.

When changes are made to the configuration file, you can check the changes 
take effect by using the restart command in i3 which is bound to Mod+Shift+r.

We can use the `set` command to define names for our workspaces to 
avoid typing the literal names more than once. This can be done by the 
following:

```
# set variables for workspace titles
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"

# switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
```

Now whenever we would like to change the title of a workspace, we can do it 
in just one place and have it take effect everywhere.

***Note: When changing the workspace names, you may experience strange 
behavior after an i3 restart such as the old workspace persisting. To correct
these issues, simply exit i3 (and your X Session) by using the Mod+Shift+q key 
combination and restart it (log back in).***

#### Using X Server Properties in i3

When a program is started, it is responsible for setting display window and 
font properties in an X Server. These properties can be used by window managers 
to define specific actions for a group of application windows during an event 
(i.e. window opening, connecting an external monitor, etc.) For instance, you can 
set your i3 config to always place google chrome on workspace 4. In order to do 
this though, we'll have to know the X Server properties of a window. To find 
these properties, we can use a program called *xprop*. In Arch Linux, xprop is 
part of the xorg-utils package (`sudo pacman -S xorg-utils`). In order to see 
the properties of a program's window, first open the program, then in a 
terminal run `xprop`. The cursor should turn into a cross hair and you should 
click on the window for which you would like to see the properties. After 
clicking on the window, output similar to the following should print to the 
terminal where you launched the xprop program:
```
XdndTypeList(ATOM) = STRING, UTF8_STRING, text/plain, text/x-moz-url, TEXT, _NETSCAPE_URL, chromium/x-renderer-taint, text/html
_NET_WM_DESKTOP(CARDINAL) = 3
WM_STATE(WM_STATE):
                window state: Normal
                icon window: 0x0
_NET_WM_USER_TIME(CARDINAL) = 22313078
WM_NORMAL_HINTS(WM_SIZE_HINTS):
                program specified location: 14, 35
                program specified minimum size: 771 by 92
WM_NAME(UTF8_STRING) = "ricing arch : Maxwell J. Morgan - Google Chrome"
_NET_WM_NAME(UTF8_STRING) = "ricing arch : Maxwell J. Morgan - Google Chrome"
XdndAware(ATOM) = BITMAP
_MOTIF_WM_HINTS(_MOTIF_WM_HINTS) = 0x2, 0x0, 0x1, 0x0, 0x0

WM_WINDOW_ROLE(STRING) = "browser"
WM_CLASS(STRING) = "google-chrome", "Google-chrome"
_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_NORMAL
_NET_WM_PID(CARDINAL) = 758
WM_LOCALE_NAME(STRING) = "en_US.UTF-8"
WM_CLIENT_MACHINE(STRING) = "ArchTop"
WM_PROTOCOLS(ATOM): protocols  WM_DELETE_WINDOW, _NET_WM_PING
```

The most useful property when configuring i3 will be the window class which is 
specified as the second value of WM_CLASS(STRING). In the above output, we can 
see google chrome's window class property is 'Google-chrome'.

In order to specify that google chrome should always open on workspace 4 we can 
use i3's `assign` command like so:

```
assign [class="Google-chrome"] $ws4
```

Now, all instances of google chrome should open on workspace 4!

#### Setting Gaps in i3-gaps

i3-gaps will not automatically configure the gaps between windows for you so 
in order to do so, you must remove the window borders and specify a gap size. 
This can be done by adding the following lines to the end of your 
configuration file:

```
# i3 gaps specific stuff below #

# disable borders
for_window [class="^.*"] border pixel 0

gaps inner 15  # gap size in pixels
```

### Wrapping Things Up

I hope I shed a bit of light on the art of ricing and more specifically how to 
get up and running with a window manager. Even though I specifically covered 
i3, most window managers are installed similarly though the configuration 
syntax will most likely differ. It's all really a matter of 
packages, configuration files, and shell scripts. The hardest part is knowing 
where all the files live, the configuration syntax, and working out the kinks!

I barely scratched the surface of what you can do with i3 and with a riced 
system in general. I plan on writing more posts in the future covering the 
various other visual components of an operating system including terminal 
emulators (and X resources in general), status bars, widget themes, and other 
tidbits like composition managers, application launchers, etc. 

I hope you'll explore more operating system customizations! Here are some extra
resources to keep you going:

+ [i3 Window Manager Documentation][11]
+ [Window Manager Wiki Article][12]
+ [Unix Porn Wiki][13]
+ [My dotfile repo][14]

And here's the shameless plug to the unix porn reddit community which inspired 
me to get into ricing in the first place:

+ [Unix Porn Community][15]


[1]: https://wiki.archlinux.org/
[2]: https://www.reddit.com/r/unixporn/wiki/themeing/dictionary#wiki_rice
[3]: https://i3wm.org/
[4]: http://xmonad.org
[5]: https://en.wikipedia.org/wiki/Rxvt
[6]: http://invisible-island.net/xterm/
[7]: https://i3wm.org/i3bar/
[8]: http://projects.haskell.org/xmobar/
[9]: https://github.com/Airblader/i3
[10]: https://github.com/Airblader/i3/wiki/Compiling-&-Installing
[11]: https://i3wm.org/docs/userguide.html
[12]: https://wiki.archlinux.org/index.php/window_manager
[13]: https://www.reddit.com/r/unixporn/wiki/index
[14]: https://github.com/mjmor/dot
[15]: https://www.reddit.com/r/unixporn/

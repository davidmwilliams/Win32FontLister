# Win32 Font Lister

A Windows desktop app to display samples from all fonts available, including uninstalled fonts from a specified device or location.

# Release

The latest version of Win32 Font Lister is available in the repo as listfonts.exe.

# History

Win32 Font Lister is an app I wrote in Delphi in 1998, and updated several times to 2003. The inspiration came when two people unrelatedly asked me in the same week if I knew of any good apps to help them print a sample of all their installed fonts.

I released it as shareware for $5. It was quite fun to get a cheque periodically, though I soon moved to various shareware sales portals.

I enjoyed receiving feedback saying my app was more aesthetic and intuitive than offerings by Adobe and Microsoft, and I also was pleased to offer the ability to display samples of uninstalled fonts, as well as installed fonts. This took some clever trickery to achieve.

In the early 2000's I moved away from Delphi to .NET, but came into Delphi again in 2014 and was delighted to see my code still opened and compiled fine. Though, I depended on QuickReports which came with earlier versions of Delphi but no longer with later versions so this could be a problem. I also originally used some commercial third-party components like TOrpheus which were no longer available for sale, but happily had released their code as open source.

In 1998 it was a big thing to call an app "Win32" indicating it was 32-bit, unlike the 16-bit apps that existed prior to Windows '95 and were still quite prevalent. As years progressed people would ask me "What's Win32 mean?" and it does, now, seem an odd naming choice. Still, the app is a symptom of its time.

Hopefully you find this interesting, and I hope my Delphi formatting style appeals.

David M Williams

# Useful features

Win32 Font Lister has a number of useful features which may not be immediately obvious.

* On the main screen in advanced mode, check or uncheck the All fonts box to immediately select or deselect all fonts with the one action. However, you may also right-click the mouse on the list of fonts to invoke a pop-up menu which has these options – plus a third, which lets you toggle the selected and unselected fonts.
* On the report preview screen, use the combo-box in the top left-hand corner of the screen to zoom in and out of the report, or have it fit to the size of your screen. However, you may also right-click the mouse on the report to invoke a pop-up menu with these same options.
* On the Font listing properties tab in advanced mode, you may enter a message to be displayed in each font. However, if you insert the sequence %f somewhere in the message, the name of the font will be substituted there. You can also use %F to display the name of the font all in upper-case.
* Don’t be afraid to use long sample text messages. The report will word-wrap and show your whole message. You can also use the Page layout tab to change the paper orientation to landscape, and get extra space this way. You can also use as many lines as you like in your sample message.
* On the report preview, you can use the arrow icons to move through the pages. However, you can also use the PgUp and PgDown keys to do the same.
* On the main screen in advanced mode, move the mouse over a font name and then right-click to export a sample of the font as a bitmap or jpeg image! This can be useful for creating quick headlines for Web pages.
* On the main screen in advanced mode, move the mouse over a font name and then right-click to view a complete character set for a font. You can resize this window and copy characters, perhaps for pasting into other documents.
* To print samples of uninstalled fonts, use advanced mode, and select the Paths tab. Add the name of the directory (or directory tree) with your uninstalled fonts, and then click Apply. Win32 Font Lister will tell you how many uninstalled fonts it found, and these will all be added to the main list on the first page, for printing or previewing as normal!

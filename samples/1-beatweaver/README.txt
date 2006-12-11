To run the Beatweaver sample:

0) 	Make sure you have the FMOD library installed.
	
	You can get it at: http://fmod.org
	
	Make sure that the library is on the search-path. 
		-	For windows, add the installation path to the PATH environment variable.
		-	For OS-X, you should be fine after running the FMOD installer.
		
	Beware that the FMOD library is copyrighted commercial software. It is however 
	free for non-commerical use if I understood correctly. for more information 
	on licensing, distribution, etc., please refer to http://fmod.org.
	
	The Neko-FMOD wrapper is released under the GNU LGPL license.

1) 	run: haxe compile.hxml
2) 	open the Flash 9 (Alpha) IDE
		- 	Open front-end/Beatweaver.flp
		- 	Open the main file, ui.fla.
		- 	Select 'File','Publish Settings','Flash','ActioScript version - Settings',
			and add the path to your local Screenweaver HX ActionScript 3 API copy.
		-	Publish the project.

Enjoy!
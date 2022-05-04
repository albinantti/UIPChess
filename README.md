# UIP2_Group6
Project repository for group 6 in User Interface Programming 2

Course project details can be found [here](https://uppsala.instructure.com/courses/45525/pages/course-project?module_item_id=481824).

## Translations

Translations are done in `translation.csv` where you enter the translation key and the translation for swedish and english.
The translation key is then entered as text on e.g. a button or label and will automatically be translated.
Translations are automatically imported when you make changes to the csv file

**Important!** The csv file can not be edited via Microsoft Excel since godot requires the csv to be saved with UTF-8 without BOM. Excel saves it in ANSI ([Read more here](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_translations.html#doc-importing-translations)). The easiest is to use VS code or LibreOffice.

## Project requirements
From the course perspective, the following requirements apply: 

* The application has to be responsive, i.e. should scale to accommodate at least 2 different screen sizes/types (significant difference).  A change from 27" to 13" is not to be considered a significant difference. 
* The app has to have interactive graphics as part of the interface. This means that the user should be able to interact with the graphics using event handlers or other means available (external controls, such as joysticks are allowed).
* The app has to contain some autonomous animation. This implies that the animation should take place or work without the need for guidance by the user.
* The app has to make use of media files (sound, video, etc.), which is added as a meaningful, integrated part of the application. 
* The app has to have an interactive tutorial/help system. A static help page is not acceptable. 

Apart from these specific requirements, the following general requirements also apply: 

* The code has to be well documented according to the specifications in a separate page on this website. Non-documented applications will not be accepted. 
* The interface has to be multi-/bilingual or use externalized strings, e.g., using a dictionary (i.e., the text strings should not be mixed in with the code). 
* There has to be an implemented UNDO/REDO if this is relevant for the application.

Finally, the application should, of course, display a usable and reasonably pleasing interface to the user! Although the aesthetics of the interface is not evaluated in itself, there should be some considerations to colours, layout and other graphic aspects of the project. 

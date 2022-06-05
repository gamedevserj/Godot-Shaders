# Godot shaders

A collection of shaders that I wrote in Unity converted to be used in Godot.

Godot version 3.2.1

## Reflective water

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water1.png" height="512">

This shader uses SCREEN_TEXTURE to display reflective image to simulate water. Just like the one in Unity it has some limitations. 

Reflection is calculated using object's position, which means if you want to have reflection from top of the object then you need to set Y axis offset to half its height. Visible height of the water object can not exceed the distance to the top of the screen.

Adjustable parameters:  
Reflection offset  
Reflection blur<sup>(1)</sup>  
Distortion  
Waves  
Shoreline  
Shoreline foam  

(1) Reflection blur is only available when project's dirver is set to GLES3, which might break effect stacking (eg. impact effect might completely remove water). A way to deal with this is described [here](https://docs.godotengine.org/ru/stable/tutorials/shading/screen-reading_shaders.html).

Here's an example of the limitations.

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water1.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water2.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Water3.png" height="256">

In the first image the water starts from the bottom of the screen and goes up to the middle. Which means its visible height is equal  to the distance to the top of the screen. In the second image camera is moved lower, which results in water height being greater than the distance to the top. In the third image the water is way higher than the middle of the screen, but its height is smaller that the distance to the top, so reflections work properly. 
Examples 2 and 3 do not feature reflections squashing, squashing the reflection results in a greater area being reflected which means that object's visible height must be smaller.

The scene contains a script that allows camera to move(WASD keys) and zoom(mouse scroll).

## Impact effect/shockwave

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/ImpactEffect.png" height="512">

Impact effect similar to the one produced by a shockwave during explosion. Can be used as a magic spell, terrain deformation effect.

Uses SCREEN_TEXTURE and offsets color using the circular gradient noise as a guide.

Click anywhere in the demo scene to produce the effect.

## Dissolve

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/Dissolve.png" height="512">

Dissolves the image using the noise as a guide.

Left click in the demo scene to dissolve sprite, right click to undo.

## Magnifying glass

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/MagnifyingGlass.png" height="512">

Magnifying glass effect. The script uses get_global_transform_with_canvas() to set the correct offset for the current position. When testing it on monitor with 1920x1080 resolution the magnification didn't work correctly if the display height was set above 850 and game window had border enabled. Without window border everything worked perfectly. 

Changing edge distortion strength to positive/negative values results in simulating glass being concave/convex. 

Use mouse wheel to zoom in/out.

## Stealth cloak effect

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/StealthCloak1.png" height="512">

Essentially this is a dissolve effect, that overlays one texture over another instead of simply changing the alpha.

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/StealthCloak1.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/StealthCloak2.png" height="256"> <img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/StealthCloak3.png" height="256">

## Grass sway effect

<img src="https://github.com/gamedevserj/Godot-Shaders/blob/master/GithubImages/GrassSway.png" height="512">

A basic grass sway effect that modifies vertex positions to skew the object. In order for the effect to work properly modify offset to make object's origin to be at the bottom.

## Circular fade out
<img src="https://raw.githubusercontent.com/gamedevserj/Images-For-Repo/main/Site/GodotFadeOutShaderTutorial/fade_out_final.gif" height="512">

Fades out to any point of the screen.

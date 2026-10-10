# Generated Sprite Sheets

All sheets use transparent backgrounds and 32 x 32 cells. Import the SVG files into Godot as textures. The SVG dimensions are the sheet dimensions; no grid lines are drawn into the artwork.

## Mouse Players

Files: `mouse_player_1.svg`, `mouse_player_2.svg`  
Sheet size: 512 x 256 px; 16 columns x 8 rows.

Columns, in groups of four frames:

| Columns | Animation |
| --- | --- |
| 0-3 | Idle |
| 4-7 | Run |
| 8-11 | Jump |
| 12-15 | Pass food |

Rows, from top to bottom: N, NE, E, SE, S, SW, W, NW. Each row is the same base pose rotated to the requested heading, not a separately redrawn directional pose. Frames contain small silhouette and prop changes for a prototype animation.

## Chef

File: `chef.svg`  
Sheet size: 512 x 256 px; 16 columns x 8 rows.

Rows use the same direction order as the mouse sheets. The four-frame column groups are Idle (0-3), Search (4-7), Chase (8-11), and Cook (12-15). Directions are rotations of the base pose. Search uses small face/alert changes; cook includes a counter, pan, and steam.

## Food

File: `food_items.svg`  
Sheet size: 256 x 160 px; 8 columns x 5 rows.

- Row 0: cheese, meat, bread, sausage, apple, fish, mushroom, carrot.
- Rows 1-4: hot pizza, soup, roast, pasta, fish, pie, vegetables, and bread. Each column is one dish; the four rows are its steam animation frames.

## Burrows and HUD

File: `burrows_hud.svg`  
Sheet size: 256 x 64 px; 8 columns x 2 rows.

- Row 0, columns 0-3: open burrow loop. Columns 4-7: partially filled burrow stages.
- Row 1, columns 0-7: HUD fill levels of 0%, 14%, 29%, 43%, 57%, 71%, 86%, and 100%.

## Godot Notes

Use a 32 x 32 region for each sprite. For the mouse and chef sheets, select the desired row for the facing direction and the four columns for its animation. For hot food, animate vertically through rows 1-4 at a fixed column. For HUD fill levels, select one frame from row 1 based on the current percentage.

These are original, compact prototype illustrations made from crisp-edged shapes. They provide a consistent layout and palette, but are not polished hand-drawn pixel animation. The eight directions are rotated approximations; redraw directional poses and expand the animation frames for production-quality movement.
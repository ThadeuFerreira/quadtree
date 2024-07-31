package game

import rl "vendor:raylib"
import "core:math"
import qt "/quadtree"



screen_width : i32 = 1000
screen_height : i32 = 1000




CELL_SIZE :: 5
CELL_COUNT_X :: 200
CELL_COUNT_Y :: 200
BRUSH_SIZE :: 10

BRUSH_SHAPE :: enum {
    SQUARE,
    CIRCLE
}

main :: proc()
{
    // Initialization
    //--------------------------------------------------------------------------------------
//    gridOffset := rl.Vector2{0,0}

//    gridInstance := grid.Make_Grid(
//     CELL_COUNT_X,
//     CELL_COUNT_Y,
//     f32(BRUSH_SIZE),
//     gridOffset,
//     CELL_SIZE,
//     rl.BLACK,
//    )

    brush_radius : f32 = BRUSH_SIZE
    brush_shape : BRUSH_SHAPE = BRUSH_SHAPE.SQUARE

    rl.InitWindow(screen_width, screen_height, "raylib [core] example - basic window");
        
    tree := qt.Make_quadtree(rl.Rectangle{0, 0, f32(screen_width), f32(screen_height)}, 4, 0)
    rl.SetTargetFPS(30) // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    rl.SetTraceLogLevel(rl.TraceLogLevel.ALL) // Show trace log messages (LOG_INFO, LOG_WARNING, LOG_ERROR, LOG_DEBUG)
    // Main game loop
    for !rl.WindowShouldClose()    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        
        mouse_pos := rl.GetMousePosition()
        
        if  rl.IsMouseButtonPressed(rl.MouseButton.LEFT){
            
            qt.insert(tree, mouse_pos)
        }
        
        if rl.IsKeyPressed(rl.KeyboardKey.SPACE){
            //toggle brush shape
            brush_shape = (brush_shape == BRUSH_SHAPE.SQUARE) ? BRUSH_SHAPE.CIRCLE : BRUSH_SHAPE.SQUARE
        }
        brush_radius += rl.GetMouseWheelMove()*5
        brush_radius = math.clamp(brush_radius, 50, 300) //clamp brush radius to 1-200
        if brush_shape == BRUSH_SHAPE.CIRCLE {
            rl.DrawCircleLinesV(mouse_pos, brush_radius/2, rl.GREEN)
            found := make([dynamic]rl.Vector2, 0,100)
            qt.query_circle(tree, mouse_pos, brush_radius/2, &found)
            for point in found {
                rl.DrawCircleV(point, 5, rl.RED)
            }
            if rl.IsMouseButtonPressed(rl.MouseButton.RIGHT){
                for p in found {
                    qt.delete_point(tree, p)
                }
            }
        }
        else {
            rect := rl.Rectangle{mouse_pos.x - brush_radius/2, mouse_pos.y -brush_radius/2, brush_radius, brush_radius}
            rl.DrawRectangleLinesEx(rect, 1, rl.GREEN)
            found := make([dynamic]rl.Vector2, 0,100)
            qt.query(tree, rect, &found)
            for point in found {
                rl.DrawCircleV(point, 5, rl.RED)
            }
            if rl.IsMouseButtonPressed(rl.MouseButton.RIGHT){
                for p in found {
                    qt.delete_point(tree, p)
                }
            }
        }
        qt.Draw(tree)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
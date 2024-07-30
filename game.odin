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
        brush_radius += rl.GetMouseWheelMove()*5
        brush_radius = math.clamp(brush_radius, 50, 300) //clamp brush radius to 1-200
        rect := rl.Rectangle{mouse_pos.x - brush_radius/2, mouse_pos.y -brush_radius/2, brush_radius, brush_radius}
        rl.DrawRectangleLinesEx(rect, 1, rl.GREEN)
        if  rl.IsMouseButtonPressed(rl.MouseButton.LEFT){
            
            qt.insert(tree, mouse_pos)
        }
        qt.Draw(tree)
        found := make([dynamic]rl.Vector2, 0,100)
        qt.query(tree, rect, &found)
        for point in found {
            rl.DrawCircleV(point, 5, rl.RED)
        }
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
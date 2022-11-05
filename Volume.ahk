F4:: Send, {Volume_Mute}
F2:: Send, {Volume_down}
F3:: Send, {Volume_up}

F7:: adj_Brightness(-10)
F8:: adj_Brightness(+10)



;-------------------------------------------------------------------------------
adj_Brightness(d) { ; useful values are: -16 .. +16
;-------------------------------------------------------------------------------
    Gamma := get_Brightness() + d
    set_Brightness(Gamma > 255 ? 255 : Gamma < 0 ? 0 : Gamma)
}



;-------------------------------------------------------------------------------
get_Brightness() { ; return current brightness (0 .. 255)
;-------------------------------------------------------------------------------
    VarSetCapacity(GB, 1536, 0)
    hDC := DllCall("GetDC", "Ptr", 0)
    DllCall("GetDeviceGammaRamp", "Ptr", hDC, "Ptr", &GB)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
    return NumGet(GB, 2, "UShort") - 128
}


;-------------------------------------------------------------------------------
set_Brightness(Gamma) { ; set brightness (0 .. 255)
;-------------------------------------------------------------------------------
    loop, % VarSetCapacity(GB, 1536) / 6 {
        N := (Gamma + 128) * (A_Index - 1)
        NumPut(N > 65535 ? 65535 : N, GB, 2 * (A_Index - 1), "UShort")
    }
    DllCall("RtlMoveMemory", "Ptr", &GB +  512, "Ptr", &GB, "Ptr", 512)
    DllCall("RtlMoveMemory", "Ptr", &GB + 1024, "Ptr", &GB, "Ptr", 512)
    hDC := DllCall("GetDC", "Ptr", 0)
    DllCall("SetDeviceGammaRamp", "Ptr", hDC, "Ptr", &GB)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
}

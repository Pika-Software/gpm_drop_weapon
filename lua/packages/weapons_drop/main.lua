if (SERVER) then

    local blacklist = {
        ["weapon_physgun"] = true,
        ["gmod_tool"] = true
    }

    local SafeRemoveEntity = SafeRemoveEntity
    local IsValid = IsValid

    local function Drop( ply, wep )
        if IsValid( wep ) then
            local class = wep:GetClass()
            if blacklist[ class ] then
                return
            end

            if (wep:GetWeaponWorldModel() == "") then
                wep:Remove()
                return
            end

            ply:DropWeapon( wep )

            timer.Simple(5, function()
                if IsValid( wep ) then
                    if IsValid( wep:GetOwner() ) then
                        return
                    end

                    SafeRemoveEntity( wep )
                end
            end)

        end
    end

    local function DropActive( ply )
        if IsValid( ply ) then
            Drop( ply, ply:GetActiveWeapon() )
        end
    end

    concommand.Add( "drop", DropActive )
    hook.Add( "DoPlayerDeath", "GPM.WeaponDrop", DropActive )

    local commands = {
        ["drop"] = true,
        ["выкинуть"] = true,
        ["drop_weapon"] = true
    }

    hook.Add("ChatCommand", "GPM.WeaponDrop", function( ply, cl_cmd, args )
        if commands[ cl_cmd:lower() ] then
            DropActive( ply )
            return ""
        end
    end)

end

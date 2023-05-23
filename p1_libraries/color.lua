---------------------------------------
------------- Color
---------------------------------------

------------- Library
colorLibrary = {
    RGB = {
        basicColors = {
            red = {
                h = 0,
                s = 100,
                v = 100,
                a = 255
            },

            green = {
                h = 120,
                s = 100,
                v = 100,
                a = 255
            },

            blue = {
                h = 240,
                s = 100,
                v = 100,
                a = 255
            },
        },

        ---@return colorRGB
        new = function(r, g, b, a)
            return {
                r = r or 255,
                g = g or 255,
                b = b or 255,
                a = a or 255
            }
        end,

        ---@param color colorRGB
        unpack = function(color)
            return color.r, color.g, color.b, color.a
        end,

        ---@param color colorRGB
        ---@return colorHSV
        toHSV = function(color)
            local r, g b, a = colorLibrary.RGB.unpack(color)

            local max_val = math.max(r, g, b)
            local min_val = math.min(r, g, b)
            local delta = max_val - min_val
            local h, s, v

            if delta == 0 then
                h = 0
            elseif max_val == r then
                h = ((g - b) / delta) % 6
            elseif max_val == g then
                h = ((b - r) / delta) + 2
            elseif max_val == b then
                h = ((r - g) / delta) + 4
            end

            h = h * 60
            if h < 0 then
                h = h + 360
            end

            if max_val == 0 then
                s = 0
            else
                s = delta / max_val
            end

            v = max_val

            return colorLibrary.HSV.new(h, s, v, a)
        end
    },

    HSV = {
        basicColors = {
            red = {
                h = 0,
                s = 100,
                v = 100,
                a = 255
            },

            green = {
                h = 120,
                s = 100,
                v = 100,
                a = 255
            },

            blue = {
                h = 240,
                s = 100,
                v = 100,
                a = 255
            },
        },

        ---@return colorHSV
        new = function(h, s, v, a)
            return {
                h = h or 360,
                s = s or 100,
                v = v or 100,
                a = a or 255
            }
        end,

        ---@param color colorHSV
        unpack = function(color)
            return color.h, color.s, color.v, color.a
        end,

        ---@param color colorHSV
        ---@return colorRGB
        toRGB = function(color)
            local h, s, v, a = colorLibrary.HSV.unpack(color)

            local c = v * s
            local x = c * (1 - math.abs((h / 60) % 2 - 1))
            local m = v - c
            local r, g, b

            if h < 60 then
                r, g, b = c, x, 0
            elseif h < 120 then
                r, g, b = x, c, 0
            elseif h < 180 then
                r, g, b = 0, c, x
            elseif h < 240 then
                r, g, b = 0, x, c
            elseif h < 300 then
                r, g, b = x, 0, c
            else
                r, g, b = c, 0, x
            end

            r, g, b = (r + m) * 255, (g + m) * 255, (b + m) * 255

            return colorLibrary.RGB.new(r, g, b, a)
        end
    },

    ---@param color colorRGB|colorHSV
    ---@return "rgb"|"hsv"|nil
    type = function(color)
        if not color.a then
            return
        end

        if color.r and color.g and color.b then
            return "rgb"
        elseif color.h and color.s and color.v then
            return "hsv"
        end
    end
}
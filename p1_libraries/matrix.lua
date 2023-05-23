---------------------------------------
------------- Matrix
---------------------------------------

------------- Library
matrix.add = function(matrix1, matrix2)
    local new = matrix.translation(0, 0, 0)

    for i, v in pairs(new) do
        if matrix1[i] and matrix2[i] then
            new[i] = matrix1[i] + matrix2[i]
        end
    end

    return new
end
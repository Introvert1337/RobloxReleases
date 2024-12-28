--[[
  Made by Intro
  Note this was made for the sole purpose of Jailbreak, it is by no means an optimized (or even good, ngl) algorithm for this puzzle
  This is a bruteforce method that will lag badly on huge or very open puzzles, it just works well for the power plant use case
  Also, this uses 0 for empty space, so add 1 to the power plant matrix items
]]

local matrixList, chosenPaths, usedPaths, pathGroups = {}, {}, {}, {}
local columns, rows

local function traverseMatrix(startingNode, direction) -- function to get the index of the node in a direction from the starting node
    if direction == "r" then
        return startingNode + 1
    elseif direction == "l" then
        return startingNode - 1
    elseif direction == "u" then
        return startingNode - rows
    elseif direction == "d" then
        return startingNode + rows
    end
end

function getPossiblePaths(node, target, visited, path, correctPaths)
    visited[node] = true -- Mark the current node as visited and add it to the path
    table.insert(path, node)

    if matrixList[node] == target and #path > 1 then -- Check if the current node meets the target condition
        table.insert(correctPaths, table.clone(path))
    else
        local possibleDirections = { -- Determine possible directions to traverse
            l = node % rows ~= 1,
            r = node % rows ~= 0,
            u = node > rows,
            d = node <= rows * (columns - 1)
        }

        for direction, allowed in possibleDirections do -- Iterate through each possible direction
            if allowed then
                local nextNode = traverseMatrix(node, direction)

                if not visited[nextNode] and (matrixList[nextNode] == 0 or matrixList[nextNode] == target) then -- Continue if the next node is valid
                    getPossiblePaths(nextNode, target, visited, path, correctPaths)
                end
            end
        end
    end

    -- Unmark the node and remove it from the current path
    visited[node] = nil
    table.remove(path)

    -- Return the collection of correct paths when the initial call completes
    if not path[1] then
        return correctPaths
    end
end

local function hasOverlap(setA, setB) -- check if 2 sets have any overlapping values
    for value in setB do
        if setA[value] then
            return true
        end
    end

    return false
end

local function removeOrUnion(setA, setB, union) -- adds/removes all values of setB to/from setA
    for value in setB do
        setA[value] = union
    end
end

local function selectNonOverlapping(groupIndex) -- select one path from each group that has no overlaps
    if groupIndex > #pathGroups then
        return true
    end
    
    for candidateIndex, candidate in pathGroups[groupIndex] do
        if not hasOverlap(usedPaths, candidate.set) then
            removeOrUnion(usedPaths, candidate.set, true)
            chosenPaths[groupIndex] = candidate
            
            if selectNonOverlapping(groupIndex + 1) then
                return true
            end

            removeOrUnion(usedPaths, candidate.set)
            chosenPaths[groupIndex] = nil
        end
    end

    return false
end

return function(matrix)
    table.clear(matrixList)
    table.clear(chosenPaths)
    table.clear(usedPaths)
    table.clear(pathGroups)

    columns = #matrix -- vertical
    rows = #matrix[1] -- horizontal

    local uniqueNodeValues = {}

    for _, row in matrix do -- create a table with all the node values unpacked
        for _, node in row do
            table.insert(matrixList, node)
        end
    end

    for _, nodeValue in matrixList do
        if nodeValue ~= 0 and not uniqueNodeValues[nodeValue] then -- get the indexes for the starting point of each unique number
            uniqueNodeValues[nodeValue] = table.find(matrixList, nodeValue)
        end
    end

    for nodeValue, nodeIndex in uniqueNodeValues do -- create groups with the original and set version of the path
        pathGroups[nodeValue] = {}

        local visited, path, correctPaths = {}, {}, {}
    
        for pathIndex, path in getPossiblePaths(nodeIndex, nodeValue, visited, path, correctPaths) do
            local set = {}
    
            for _, node in path do
                set[node] = true
            end
    
            pathGroups[nodeValue][pathIndex] = {
                original = path,
                set = set
            }
        end
    end

    if selectNonOverlapping(1) then -- if non overlapping paths from each group are found
        for pathNumber, path in chosenPaths do -- update matrixlist to add the correct paths
            for _, nodeValue in path.original do
                matrixList[nodeValue] = pathNumber
            end
        end
    else
        return print("No combination of non-overlapping tables found.")
    end
    
    local solvedMatrix = {}
    
    for _ = 1, columns do -- create an empty 
        table.insert(solvedMatrix, {})
    end
    
    for nodeIndex, nodeValue in matrixList do
        table.insert(solvedMatrix[math.ceil(nodeIndex / rows)], nodeValue)
    end

    return solvedMatrix
end

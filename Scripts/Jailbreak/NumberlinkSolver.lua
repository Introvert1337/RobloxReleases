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

local function getPossiblePaths(node, target, path, correctPaths) -- function to get all possible paths from starting point to end
    correctPaths = correctPaths or {}

    if path then
        if matrixList[node] == target then -- we have reached end point, this is a valid path
            return table.insert(correctPaths, path.nodes)
        end

        path.visited[node] = true
        table.insert(path.nodes, node)
    else
        path = { nodes = {}, visited = { [node] = true } }
    end

    local possibleDirections = {
        l = node % rows ~= 1, -- check if node is not on the left edge (one greater than a multiple of the rows)
        r = node % rows ~= 0, -- check if node is not on the right edge (multiple of the rows)
        u = node > rows, -- check if node is not on the top row (greater than the rows)
        d = node < rows * (columns - 1) + 1 -- check if node is not on the bottom row (less than lowest index of bottom row)
    }

    for direction, allowed in possibleDirections do
        if not allowed then
            continue
        end
        
        local nextNode = traverseMatrix(node, direction)

        if path.visited[nextNode] or (matrixList[nextNode] ~= 0 and matrixList[nextNode] ~= target) then -- if node has already been visited or it is occupied
            continue
        end

        getPossiblePaths(nextNode, target, {
            nodes = table.clone(path.nodes),
            visited = table.clone(path.visited)
        }, correctPaths)
    end

    return correctPaths
end

local function hasOverlap(setA, setB) -- check if 2 sets have any overlapping values
    for value in setB do
        if setA[value] then
            return true
        end
    end

    return false
end

local function unionInto(setA, setB) -- adds all values of setB to setA
    for value in setB do
        setA[value] = true
    end
end

local function removeFrom(setA, setB) -- removes all values of setB from setA
    for value in setB do
        setA[value] = nil
    end
end

local function selectNonOverlapping(groupIndex) -- select one path from each group that has no overlaps
    if groupIndex > #pathGroups then
        return true
    end
    
    for candidateIndex, candidate in pathGroups[groupIndex] do
        if not hasOverlap(usedPaths, candidate.set) then
            unionInto(usedPaths, candidate.set)
            chosenPaths[groupIndex] = candidate
            
            if selectNonOverlapping(groupIndex + 1) then
                return true
            end

            removeFrom(usedPaths, candidate.set)
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
    
        for pathIndex, path in getPossiblePaths(nodeIndex, nodeValue) do
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

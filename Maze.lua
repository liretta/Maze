
--looking for neighbors
function FindNeighbors(i)
    neighbors = {}
    if BaseMaze[i-1] == 1 or BaseMaze[i-1] == 3 or BaseMaze[i-1] == 2 then table.insert(neighbors, i-1) end --left neighbor
    if BaseMaze[i+1] == 1 or BaseMaze[i+1] == 3 or BaseMaze[i+1] == 2 then table.insert(neighbors, i+1) end --right neighbor
    if BaseMaze[i-n] == 1 or BaseMaze[i-n] == 3 or BaseMaze[i-n] == 2 then table.insert(neighbors, i-n) end --neighbor on top
    if BaseMaze[i+n] == 1 or BaseMaze[i+n] == 3 or BaseMaze[i+n] == 2 then table.insert(neighbors, i+n) end --bottom neighbor

    return neighbors
end

--looking for a way
function FindTheWay(StartPoint)
    QueueForCheck = {}
    NodesWithCost = {}

	NodesWithCost[StartPoint] = 0 --key = number of cell, value = cost this cell by the way
    CurNodeNumber = StartPoint
    k = 0 -- step in queue

    while NodesWithCost[ExitPoint] ==nil do --while we not mark the finish

        for i = 1, #Node[CurNodeNumber] do --for each neaghbor
            if Node[CurNodeNumber][i] == ExitPoint then
                NodesWithCost[Node[CurNodeNumber][i]] = NodesWithCost[CurNodeNumber]+1 --added to the table cost of current cell
                return true
            else
                if NodesWithCost[Node[CurNodeNumber][i]] == nil then --if i-neighbor isn't mark as checked
                    NodesWithCost[Node[CurNodeNumber][i]] = NodesWithCost[CurNodeNumber]+1
                    table.insert(QueueForCheck, Node[CurNodeNumber][i]) -- add this neighbor to queue for checking
                end
            end
        end

        --go to next step
        k = k +1
        --take the next Node
        CurNodeNumber = QueueForCheck[k]
    end

    return false

end


function RecoveryTheWay(ExitPoint)
    -- take the current Node
    -- looking for a neighbor with a cost of 1 less
    -- repeat until current Node isn't StartPoint

    Way = {}
	local NeighborsNode = {}

	CurNode = ExitPoint
	CurCost = NodesWithCost[CurNode]

	while CurNode ~= StartPoint do
		for i = 1, #Node[CurNode] do
			NeighborsNode[i] = Node[CurNode][i] -- added to check-list all neighbors
		end

	   for i=1, #NeighborsNode do
		if NeighborsNode[i] == StartPoint then
			return Way
	    elseif NodesWithCost[NeighborsNode[i]] == CurCost-1 then
			table.insert(Way, NeighborsNode[i])
            CurNode = NeighborsNode[i]
			CurCost = CurCost -1
			end
        end
    end
    return Way
end



--main
local FileAdress = "D:\\LUA\\tests\\labirint\\Maze.txt"
local FileRead = io.open(FileAdress, "r")
local ReadData = FileRead:read("*l")

if ReadData == nil then
	local FileWriteAdress = "D:\\LUA\\tests\\labirint\\result.txt"
	local FileWrite = io.open(FileWriteAdress, "w")
	FileWrite:write("Error with open file")
	FileWrite:close()
else


--by defolt the maze surrounded by the wall regardless of the file
--creat firs wall, then - reading from file
n = #ReadData+2 --lenght by 1 line in maze = lenght line from file +2 additional wall from raght and left
BaseMaze = {}
for i =1, n do
    table.insert(BaseMaze, 0)
end

while ReadData~=nil do
    table.insert(BaseMaze, 0) --first element of each line should be the wall

    for str in string.gmatch(ReadData, ".") do
        if str == "0" or str == 0 then
            table.insert(BaseMaze, 0)
        elseif str == "I" then
            table.insert(BaseMaze, 2)
            StartPoint = #BaseMaze --saving start cell number
        elseif str == "E" then
            table.insert(BaseMaze, 3)
            ExitPoint = #BaseMaze --saving exit cell number
        else
            table.insert(BaseMaze, 1)
        end
    end

    table.insert(BaseMaze, 0) --last element from each line should be the wall
	ReadData = FileRead:read("*l")
end
FileRead:close()

--add last line with the wall
for i =1, n do
    table.insert(BaseMaze, 0)
end


Node = {} --key == node number, value = table with all neighbors by this Node

for i=1, #BaseMaze do
    if BaseMaze[i] == 1 or BaseMaze[i] == 2 or BaseMaze[i] == 3 then
		tmp_node = FindNeighbors(i)
		Node[i] = tmp_node
        tmp_node = nil
    end
end


local FileWriteAdress = "D:\\LUA\\tests\\labirint\\result.txt"
local FileWrite
FileWrite = io.open(FileWriteAdress, "w")

FindTheWay(StartPoint)
if NodesWithCost[ExitPoint]~= nil then
	NewWay = RecoveryTheWay(ExitPoint)
    if NewWay ~= nil then
        for i=1, #NewWay do
			BaseMaze[NewWay[i]] = 5
        end
    end
    for i=1, #BaseMaze, n do
        for j = i, i+n-1 do
            if BaseMaze[j] == 0 then
                FileWrite:write(0)
            elseif BaseMaze[j] == 1 then
                FileWrite:write(" ")
            elseif BaseMaze[j] == 2 then
                FileWrite:write("I")
            elseif BaseMaze[j] == 3 then
                FileWrite:write("E")
            elseif BaseMaze[j] == 5 then
                FileWrite:write("/")
            end
        end
        FileWrite:write("\n")
    end
    FileWrite:close()
else
	FileWrite:write("There isn't any way from start to finish.Sorry :-(")
    FileWrite:close()

end
end


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

	NodesWithCost[StartPoint] = 0
    CurNodeNumber = StartPoint
    k = 0 -- step in queue

    while NodesWithCost[ExitPoint] ==nil do --while we not mark the finish

        for i = 1, #Node[CurNodeNumber] do --��� ������� ������
            if Node[CurNodeNumber][i] == ExitPoint then
                --table.insert(NodesWithCost, Node[CurNodeNumber][i], NodesWithCost[CurNodeNumber]+1)
                NodesWithCost[Node[CurNodeNumber][i]] = NodesWithCost[CurNodeNumber]+1
                return true
            else
                if NodesWithCost[Node[CurNodeNumber][i]] == nil then --���������, ��� i-� �� ����� ����� ��� �� �������
                    --table.insert(NodesWithCost, Node[CurNodeNumber][i] = NodesWithCost[CurNodeNumber]+1)
                    NodesWithCost[Node[CurNodeNumber][i]] = NodesWithCost[CurNodeNumber]+1
                    table.insert(QueueForCheck, Node[CurNodeNumber][i]) -- ��������� ����� ������ � ������ �� �������� �������
                end
            end
        end

        --��������� � ���������� ������� � ������� ��������
        k = k +1
        --������������� ���������� ������������
        CurNodeNumber = QueueForCheck[k]
    end

    return false

end

    --�������������� ����
function RecoveryTheWay(ExitPoint)
    -- ������� ����� �������� ������, ���������� ������ �� 1 ������ ����� � ������� ������
    -- ������� � ��������� ������ � �������� � � ����
    -- ���� ������� ������ � �� ���������
    -- ������� ���� ������
    print("Start function\n")
	Way = {}
	local NeighborsNode = {}

	print("ExitPoint = ", ExitPoint)
	print("StartPoint = ", StartPoint)
    CurNode = ExitPoint
	print("CurNode = ", CurNode)

	CurCost = NodesWithCost[CurNode]
    print("curCost= ", CurCost)

	while CurNode ~= StartPoint do
		print("Start while")
		print("Node[CurNode] = ", Node[CurNode])
		print("#Node[CurNode] = ", #Node[CurNode])
		for i = 1, #Node[CurNode] do
			print("Start loop for, i= ", i)

			NeighborsNode[i] = Node[CurNode][i] -- ��������� �� �������� ������ ������� ������� ����
			print("Neighbors list for checking = ", NeighborsNode[i])
		end

	   for i=1, #NeighborsNode do
			print("start second loop for. i = ",i)
		if NeighborsNode[i] == StartPoint then
			print("NodesWithCost[NeighborsNode[i]] == StartPoint", NodesWithCost[NeighborsNode[i]])
			return way
	    elseif NodesWithCost[NeighborsNode[i]] == CurCost-1 then
			print("Inside elseif NodesWithCost[NeighborsNode[i]] = ", NodesWithCost[NeighborsNode[i]])
            table.insert(Way, NeighborsNode[i])
            CurNode = NeighborsNode[i]
			print("Now curNode = ", CurNode)
            CurCost = CurCost -1
			print("now curCost = ", CurCost)
            end
        end
		print("End while-iteration. Way = ", Way[#Way])
    end
	print("Return Way. Way# = ", #Way)
    return Way
end



--main
local FileAdress = "D:\\LUA\\tests\\labirint\\Maze.txt"
local FileRead

FileRead = io.open(FileAdress, "r")
local ReadData
ReadData = FileRead:read("*l")

if ReadData == nil then
	local FileWriteAdress = "D:\\LUA\\tests\\labirint\\result.txt"
	local FileWrite

	FileWrite = io.open(FileWriteAdress, "w")
	FileWrite:write("Error with open file")
	FileWrite:close()
else


--�������� ��-��������� ������� ������
--������� ����� ������, ����� - ������ �������� �� �����
n = #ReadData+2 --������ ������ = ����� ������ � ����� + ��� �������������� ������� "����" ������ � �����
BaseMaze = {}
for i =1, n do
    table.insert(BaseMaze, 0)
end

while ReadData~=nil do
    table.insert(BaseMaze, 0) --������ ������� ������ ������ - �����

    for str in string.gmatch(ReadData, ".") do
        if str == "0" or str == 0 then
            table.insert(BaseMaze, 0)
        elseif str == "I" then
            table.insert(BaseMaze, 2)
            StartPoint = #BaseMaze --���������� ����� ������, � ������� ������ ��� �������� ������� "������"
        elseif str == "E" then
            table.insert(BaseMaze, 3)
            ExitPoint = #BaseMaze --����� ������ ������
        else
            table.insert(BaseMaze, 1)
        end
    end

    table.insert(BaseMaze, 0) --��������� ������� ������ ������� ���� �����
	ReadData = FileRead:read("*l")
end
FileRead:close()

--�������� ������ ������ ����
for i =1, n do
    table.insert(BaseMaze, 0)
end


Node = {} --���� ���� = ��������� ��� ������� ������ ���������

for i=1, #BaseMaze do
    if BaseMaze[i] == 1 or BaseMaze[i] == 2 or BaseMaze[i] == 3 then
		tmp_node = FindNeighbors(i)
		Node[i] = tmp_node
        --table.insert(Node, tmp_node)
        tmp_node = nil
    end
end


local FileWriteAdress = "D:\\LUA\\tests\\labirint\\result.txt"
local FileWrite
FileWrite = io.open(FileWriteAdress, "w")

FindTheWay(StartPoint)
if NodesWithCost[ExitPoint]~= nil then
	--local NewWay = RecoveryTheWay(ExitPoint)
	RecoveryTheWay(ExitPoint)
	NewWay = Way
	print("#NewWay = ", #NewWay)
	print("NewWay = ", NewWay[#NewWay])
    if NewWay ~= nil then
		print("Inside if")
        for i=1, #NewWay do
			print("Inside for, numb = ", NewWay[i])
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
                FileWrite:write("$")
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

--looking for neighbors
function FindNeighbors(i)
    neighbors = {}
    if BaseMaze[i-1] == 1 or BaseMaze[i-1] == 3 or BaseMaze[i-1] == 2 then table.insert(neighbors, i-1) end --����� �����
    if BaseMaze[i+1] == 1 or BaseMaze[i+1] == 3 or BaseMaze[i+1] == 2 then table.insert(neighbors, i+1) end --����� ������
    if BaseMaze[i-n] == 1 or BaseMaze[i-n] == 3 or BaseMaze[i-n] == 2 then table.insert(neighbors, i-n) end --����� ������
    if BaseMaze[i+n] == 1 or BaseMaze[i+n] == 3 or BaseMaze[i+n] == 2 then table.insert(neighbors, i+n) end --����� �����

    return neighbors
end

--looking for a way
	QueueForCheck = {}
    NodesWithCost = {}
function FindTheWay(StartPoint)
    --QueueForCheck = {}
    --NodesWithCost = {}

	NodesWithCost[StartPoint] = 0
    --table.insert(NodesWithCost, start, 0)
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
    Way = {}
	NeighborsNode = {}
    CurNode = ExitPoint
    curCost = NodesWithCost[CurNode]
    while CurNode ~= StartPoint do
		for i = 1, #Node[CurNode] do
			NeighborsNode[i] = Node[CurNode][i] -- ��������� �� �������� ������ ������� ������� ����
		end

	   for i=1, #NeighborsNode do
            if NodesWithCost[NeighborsNode[i]] == StartPoint then break
            elseif NodesWithCost[NeighborsNode[i]] == curCost-1 then
                table.insert(Way, NeighborsNode[i])
                curNode = NeighborsNode[i]
                curCost = curCost -1
            end
        end
    end
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
NewWay = RecoveryTheWay(ExitPoint)
    if NewWay ~= nil then
        for numb in NewWay do
            BaseMaze[numb] = "-"
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
            elseif BaseMaze[j] == "-" then
                FileWrite:write("-")
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



--[[if FindTheWay(StartPoint) == true or NodesWithCost[ExitPoint] ~= nil then
-- ���� ������� ���� ��� �������� �������� ������
    NewWay = RecoveryTheWay(ExitPoint)
    if NewWay ~= nil then
        for numb in NewWay do
            BaseMaze[numb] = "-"
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
            elseif BaseMaze[j] == "-" then
                FileWrite:write("-")
            end
        end
        FileWrite:write("\n")
    end
    FileWrite:close()
else

    FileWrite:write("There isn't any way from start to finish.Sorry :-(")
    FileWrite:close()
end]]

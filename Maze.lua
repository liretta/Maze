
function FindNeighbors(i)
	neighbors = {}
	if BaseMaze[i-1] == 1 or BaseMaze[i-1] == 3 or BaseMaze[i-1] == 2 then table.insert(neighbors, i-1) end --сосед слева
	if BaseMaze[i+1] == 1 or BaseMaze[i+1] == 3 or BaseMaze[i+1] == 2 then table.insert(neighbors, i+1) end --сосед справа
	if BaseMaze[i-n] == 1 or BaseMaze[i-n] == 3 or BaseMaze[i-n] == 2 then table.insert(neighbors, i-n) end --сосед сверху
	if BaseMaze[i+n] == 1 or BaseMaze[i+n] == 3 or BaseMaze[i+n] == 2 then table.insert(neighbors, i+n) end	--сосед снизу

	return neighbors
end

--функция поиска пути. Вернет true, если финальная точна достигнута
--вернет false, если достигнуть финальной точки не удалось - выхода для нас нет
function FindTheWay(StartPoint)
--для каждого соседа с числом "d"
--если сосед не в списке проверенных и в списке цены его тоже нет
--добавляем его в очередь на проверку

--нужна очередь для проверки
--очередь со стоимостью
--очередь проверенных

	QueueForCheck = {}
	NodesWithCost = {}
	--ChecikgNodes = {}

--помечаем стартовую ячейку нулем
	table.insert(NodesWithCost, start = 0)
	CurNodeNumber = start
	--d = 0 -- текущая стоимость
	k = 0 -- шаг в очереди

while --[[QueueForCheck~= nil and ]] NodesWithCost[ExitPoint] ~=nil do --пока еще есть что проверять и пока финиш не помечен

	--for node in NodesWithCost do
	--if node == d --если текущая нода в списке стоимости == текущей стоимости

	for i = 1, #Node[CurNodeNumber] do --для каждого соседа
		if Node[CurNodeNumber][i] == ExitPoint
			table.insert(NodesWithCost, Node[CurNodeNumber][i] = NodesWithCost[CurNodeNumber]+1)
			return true
		else
			if NodesWithCost[Node[CurNodeNumber][i]] == nil then --проверяем, что i-й по счету сосед еще не помечен
				table.insert(NodesWithCost, Node[CurNodeNumber][i] = NodesWithCost[CurNodeNumber]+1)
				--помечаем соседа как d+1
				table.insert(QueueForCheck, Node[CurNodeNumber][i]) -- добавляем этого соседа в список на проверку соседей
			end
		end
	end

	--[[увеличиваем стоимость
	d = d + 1]]
	--переходим к следующему объекту в очереди проверок
	k = k +1
	--устанавливаем следующего проверяемого
	CurNodeNumber = QueueForCheck[k]
end

	return false
end



--!!!! реализовать!!
--восстановление пути
function RecoveryTheWay(ExitPoint)
	-- выбрать среди соседних ячейку, помеченную числом на 1 меньше числа в текущей ячейке
    -- перейти в выбранную ячейку и добавить её к пути
	-- ПОКА текущая ячейка — не стартовая
	-- ВОЗВРАТ путь найден
	Way = {}
	CurNode = ExitPoint
	curCost = NodesWithCost[CurNode]
	while CurNode ~= StartPoint do

		NeighborsNode = Node[CurNode] -- добавляем на проверку список соседей текущей ноды
		for i=1, #NeighborsNode do
			if NodesWithCost[NeighborsNode[i]] == StartPoint then break
			elseif NodesWithCost[NeighborsNode[i]] == curCost-1 then
				table.insert(Way, NeighborsNode[i])
				curNode = Neighbors[i]
				curCost = curCost -1
			end
		end
	end
	return Way
end



--main
local FileAdress = "D:\\LUA\\tests\\read_files\\Maze.txt"
local FileRead

FileRead = io.open(FileAdress, "r")
ReadData = FileRead:read("*l")

--лабиринт по-умолчанию окружен стеной
--создаем стену сверху, после - читаем лабиринт из файла
n = #ReadData+2 --размер строки = длина строки в файле + два дополнительных столбца "стен" справа и слева
BaseMaze = {}
for i =1, n do
	table.insert(BaseMaze, 0)
end

while ReadData~=nil do
	table.insert(BaseMaze, 0) --первый элемент каждой строки - стена

	for str in string.gmatch(ReadData, ".") do
		if str == 0 then
			table.insert(BaseMaze, 0)
		elseif str == "I"
			table.insert(BaseMaze, 2)
			StartPoint = #BaseMaze --записываем номер ячейки, в которую только что добавили отметку "старта"
		elseif str == "E"
			table.insert(BaseMaze, 3)
			ExitPoint = #BaseMaze --номер ячейки выхода
		else
			table.insert(BaseMaze, 1)
		end
	end

	table.insert(BaseMaze, 0) --последний элемент каждой строчки тоже стена
end
FileRead:close()

--добавить нижнюю строку стен
for i =1, n do
	table.insert(BaseMaze, 0)
end

Node = {} --наши узлы = свободные для прохода ячейки лабиринта

for i=1, #BaseMaze do
	if BaseMaze[i] == 1 or BaseMaze[i] == 2 or BaseMaze[i] == 3
		tmp_node = {i = FindNeighbors(i)}
		table.insert(Node, tmp_node)
		tmp_node = nil
	end
end


local FileWriteAdress = "D:\\LUA\\tests\\labirint\\result.txt"
local FileWrite
FileWrite = io.open(FileWriteAdress, "w")

if FindTheWay(StartPoint) = true or NodesWithCost[ExitPoint] ~= nil then
-- если нашелся путь или помечена финишная ячейка
	NewWay = RecoveryTheWay(ExitPoint)
	if NewWay ~= nil then
		for numb in NewWay
			BaseMaze[numb] = "-"
		end
	end
end

	for i=1, #BaseMaze, n do
		for j = i, i+n-1 do
			if BaseMaze[j] == 0
				FileWrite:write(0)
			elseif BaseMaze[j] == 1
				FileWrite:write(" ")
			elseif BaseMaze[j] == 2
				FileWrite:write("I")
			elseif BaseMaze[j] == 3
				FileWrite:write("E")
			elseif BaseMaze[j] == "-"
				FileWrite:write("-")
			end
		end
		FileWrite:write("\n')
	end

else

	FileWrite:write("There isn't any way from start to finish.Sorry :-(")
	FileWrite:close()
end


















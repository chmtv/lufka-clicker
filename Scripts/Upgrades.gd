class Upgrade:
	var cost
	var additiveMultiplier = 0
	var multiplicativeMultiplier = 0
	var name
	var description = ''
	var buildingID # the index of the building to upgrade
	var bought = false
	var globalMultiplier = 1
	var buildingLevel = 0
	func afterBuy():
		pass
	func _init(_name = "Brak nazwy", _description = "", _buildingID = 0 ,_cost = 0, _additiveMultiplier = 0, _multiplicativeMultiplier = 0, _buildingLevel = 0):
		name = _name
		description = _description
		cost = _cost
		additiveMultiplier = _additiveMultiplier
		multiplicativeMultiplier = _multiplicativeMultiplier
		buildingID = _buildingID
		buildingLevel = _buildingLevel

class AdditiveMultiplierUpgrade extends Upgrade:
	func _init(_name, _description, _buildingID, _cost, _multiplier, _buildingLevel = 0):
		name = _name
		description = _description
		cost = _cost
		additiveMultiplier = _multiplier
		buildingID = _buildingID
		buildingLevel = _buildingLevel
class MultiplicativeMultiplierUpgrade extends Upgrade:
	func _init(_name, _description, _buildingID, _cost, _multiplier, _buildingLevel = 0):
		name = _name
		description = _description
		cost = _cost
		multiplicativeMultiplier = _multiplier
		buildingID = _buildingID
		buildingLevel = _buildingLevel
class GlobalAdditiveUpgrade extends Upgrade:
	func _init(_name, _description, _cost, _multiplier):
		name = _name
		description = _description
		cost = _cost
		globalMultiplier = _multiplier
class MapUpgrade extends Upgrade:
	var mapPath
	func _init(_name, _description, _cost, _multiplier, _mapPath):
		name = _name
		description = _description
		cost = _cost
		globalMultiplier = _multiplier
		mapPath = _mapPath

enum BuildingIds {
	Zapalniczka,
	Jablko,
	Lufka,
	Butla,
	Wiadro,
	SzBonga,
	GravBonga,
	Pluca
}

var upgrades = [
	AdditiveMultiplierUpgrade.new("Mechanizm zapalający", "Przycisk zapalniczki zrobiony z lżejszego plastiku dodaje wygody", BuildingIds.Zapalniczka, 10, 0.5, 5),
	AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 50, 0.5, 10),
	AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 50, 0.5, 25),
	MultiplicativeMultiplierUpgrade.new("Precyzyjne cięcie I", "", BuildingIds.Jablko, 20, 0.5, 10),
	MultiplicativeMultiplierUpgrade.new("Precyzyjne cięcie II", "", BuildingIds.Jablko, 200, 0.5, 25),
	MultiplicativeMultiplierUpgrade.new("Lufka I", "", BuildingIds.Lufka, 2000, 1, 15),
	MultiplicativeMultiplierUpgrade.new("Lufka I", "", BuildingIds.Lufka, 2000, 0.5, 30),
	

]

# Stare ulepszenia :>
#	MultiplicativeMultiplierUpgrade.new("Lepszy gaz I", "", 1, 100, 0.15),
#	MultiplicativeMultiplierUpgrade.new("Lepszy gaz II", "", 1, 1000, 0.15),
#	AdditiveMultiplierUpgrade.new("Wytrzymałość szkła I", "", 2, 500, 0.3),
#	AdditiveMultiplierUpgrade.new("Wytrzymałość szkła II", "", 2, 1250, 0.5),
#	MultiplicativeMultiplierUpgrade.new("Lepsza odmiana I", "", 3, 2500, 0.2),
#	MultiplicativeMultiplierUpgrade.new("Lepsza odmiana II", "", 3, 5000, 0.2),
#	MultiplicativeMultiplierUpgrade.new("Lepsza odmiana III", "", 3, 7500, 0.2),
#	MultiplicativeMultiplierUpgrade.new("Przeworski Haze", "", 3, 12000, 1.2),
#	AdditiveMultiplierUpgrade.new("Wodne filtrowanie I", "", 4, 15000, 1),
#	AdditiveMultiplierUpgrade.new("Wodne filtrowanie II", "", 4, 20000, 0.8),
#	AdditiveMultiplierUpgrade.new("Wodne filtrowanie III", "", 4, 30000, 0.6),
#	MultiplicativeMultiplierUpgrade.new("Paragon I", "", 5, 45000, 0.8),
#	MultiplicativeMultiplierUpgrade.new("Paragon II", "", 5, 80000, 1.2),
#	MultiplicativeMultiplierUpgrade.new("Paragon III", "", 5, 139000, 1.5),
#	AdditiveMultiplierUpgrade.new("Zakrycie rękoma I","",6, 150000, 0.5),
#	AdditiveMultiplierUpgrade.new("Zakrycie rękoma II","",6, 300000, 0.5),
#	AdditiveMultiplierUpgrade.new("Zakrycie rękoma III","",6, 450000, 1),
#	AdditiveMultiplierUpgrade.new("Pojemność płuc I","",7, 175000, 1.5),
#	AdditiveMultiplierUpgrade.new("Pojemność płuc II","",7, 240000,1.9),
#	AdditiveMultiplierUpgrade.new("Pojemność płuc III","",7, 380000, 2.4),
#	AdditiveMultiplierUpgrade.new("Aorta ciemiężnego alfonsa", "", 1, 5000000, 500),
#	AdditiveMultiplierUpgrade.new("Kammerurlo gówno z cebulą", "", 2, 7000000, 500),

var mapUpgrades = [
	MapUpgrade.new("Mostki", "", 500, 0.1, "mostki.jpg"),
	MapUpgrade.new("Altana", "", 2500, 0.2, "altana.jpg"),
	MapUpgrade.new("Staromieście", "", 10000, 0.2, "staromiescie.jpg"),
	MapUpgrade.new("Spiżarnia", "", 20000, 0.2, "spizarnia.jpg"),
	MapUpgrade.new("Piekło", "", 50000, 0.5, "piejlo.jpg"),
	MapUpgrade.new("Narnia", "", 700000, 0.3, "mostkiReal.jpg"),
	MapUpgrade.new("Diamentowy Las", "", 10000000, 0.3, "Diamentowylas.jpg"),
	MapUpgrade.new("Speluna", "", 80000000, 0.3, "speluna.jpg"),
	MapUpgrade.new("Dom Pompki", "", 200000000, 0.3, "lilpump.jpg"),
	MapUpgrade.new("Plac za Gurkom", "", 0.1, 0.4, "placZaGorka.jpg")
]

# wynajmuje ogrodki dzialkowe i sadze tam skuna
# splacam pozyczke kruwaaaaaa

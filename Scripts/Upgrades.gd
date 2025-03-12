# The series upgrades (the ones that act like buildings) are in Manager.gd
# Why?
# I'm fucking fried 24/7 and can't think for shit that's why

enum UnlockUpgsIDs {
	Samara,
	Growbox
}

class Upgrade:
	var cost
	var additiveMultiplier = 0
	var multiplicativeMultiplier = 0
	var name
	var description = ''
	var buildingID # the index of the building to upgrade
	var bought = false
	var globalMultiplier = -1
	var buildingLevel = 0
	var burnRateMultplier = 1
	var specialID
	func afterBuy():
		pass
	func _init(_name = "Brak nazwy", _description = "",_cost = 0, _specialID = -1):
		name = _name
		description = _description
		specialID = _specialID
		cost = _cost
		# additiveMultiplier = _additiveMultiplier
		# multiplicativeMultiplier = _multiplicativeMultiplier
		# buildingID = _buildingID
		# buildingLevel = _buildingLevel

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
class BurnRateUpgrade extends Upgrade:
	# Additive upgrade to burn the burn button hold rate, increasing and decreasing
	func _init(_name, _description, _cost, _burnRateMultiplier, _burnDrainMultiplier):
		name = _name
		description = _description
		cost = _cost
		# Kurw ale sie najebalem jak to pisaleeeeem jaa pierddollllllleeeeeeeeeeeeeeeeee
		# burnRateMultiplier = _burnRateMultiplier
class SeriesPropertyUpgrade extends Upgrade:
	var propertyName : String
	var costExponent : float
	var propertyIncrease : float
	var level = 0
	func _init(_name, _description, _propertyName, _costExponent, _propertyIncrease):
		name = _name
		description = _description
		propertyName = _propertyName
		costExponent = _costExponent
		propertyIncrease = _propertyIncrease # The property increases linearly
enum BuildingIds {
	Zapalniczka,
	Jablko,
	Lufka,
	Butla,
	Wiadro,
	Bongo,
	Joint,
	Wapo,
	Dab,
	Klepsydra,
	Wulkan,
}

var upgrades = [
	# SeriesPropertyUpgrade.new("chuj wie", "THC +%", "thcAddSeriesMult", 1.5, 1),

	# Zapalniczka
	AdditiveMultiplierUpgrade.new("Mechanizm zapalający", "Przycisk zapalniczki zrobiony z lżejszego plastiku dodaje wygody", BuildingIds.Zapalniczka, 5, 1, 5),
	AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 10, 1, 10),
	MultiplicativeMultiplierUpgrade.new("Zapasowy gaz", "Zapasy butli z płynem do zapalniczek rozwiązuje problem pustych zapalniczek", BuildingIds.Zapalniczka, 1500, 5, 25), # too much
		AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 10000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Zapalniczka - Mastery", "a chuj nie mastery", BuildingIds.Zapalniczka, 1000000000, 4.2, 75),
	MultiplicativeMultiplierUpgrade.new("Zapalniczka - Mastery", "", BuildingIds.Zapalniczka, 1500, 2.5, 75),
	# Jabłko
	MultiplicativeMultiplierUpgrade.new("Precyzyjne cięcie", "Wprawa w wycinaniu pozwala zrobić wygodniejsze jabłko", BuildingIds.Jablko, 300, 1.5, 5),
	MultiplicativeMultiplierUpgrade.new("Chuj wie", "Jak można ulepszyć jabłko????", BuildingIds.Jablko, 2000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Jablko III", "tu jakies sick ulepszenie powinno byc bo powoduje ze jablko jest lepsze niz lufa i zapalara", BuildingIds.Jablko, 6000, 3, 20),
	MultiplicativeMultiplierUpgrade.new("Jablko III", "tu jakies sick ulepszenie powinno byc bo powoduje ze jablko jest lepsze niz lufa i zapalara", BuildingIds.Jablko, 10000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Jablko - Mastery", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Jablko, 1000000000, 4.2, 75),
	# Lufka
	AdditiveMultiplierUpgrade.new("Pojemność+", "Więcej miejsca na weed", BuildingIds.Lufka, 10000, 0.4, 5),
	# AdditiveMultiplierUpgrade.new("Lufka II", "", BuildingIds.Lufka, 75000, 0.4, 10), # I don't think this one is necesssary
	MultiplicativeMultiplierUpgrade.new("Hartowane szkło", "Hartowane szkło zwiększa odporność na pęknięcia od żaru", BuildingIds.Lufka, 200000, 1.4, 15),
	Upgrade.new("Kontakty I", "Odblokowywuje samary z tematem z efektami ubocznymi po spaleniu", 100000, UnlockUpgsIDs.Samara),
	MultiplicativeMultiplierUpgrade.new("Opalanie lufki", "Wchodzisz na niebezpieczny grunt...", BuildingIds.Lufka, 3500000, 5, 30),
	AdditiveMultiplierUpgrade.new("Turbo dojebany upg do lufki", "", BuildingIds.Lufka, 50000000, 5, 50),
	# AdditiveMultiplierUpgrade.new("Lufka I", "", BuildingIds.Lufka, 2000, 2, 50),
	# Wodospad
	MultiplicativeMultiplierUpgrade.new("Wprawa", "Wprawa w wypalaniu otworu pomocna w wydajnym i wygodnym paleniu", BuildingIds.Butla, 1000000, 1.5, 5),
	MultiplicativeMultiplierUpgrade.new("Wodospad II", "", BuildingIds.Butla,  5000000, 1.5, 10),
	MultiplicativeMultiplierUpgrade.new("Wodospad III", "", BuildingIds.Butla, 30000000, 1.5, 25),
	MultiplicativeMultiplierUpgrade.new("Wodospad IV", "", BuildingIds.Butla,  100000000, 1.5, 40),
	# Wiadro
	MultiplicativeMultiplierUpgrade.new("Wiadro I", "", BuildingIds.Wiadro, 500000000, 1.5, 10),
	# MultiplicativeMultiplierUpgrade.new("Wiadro II", "", BuildingIds.Wiadro, 50000, 1,5, 15), to jest troche niepotrzebne
	MultiplicativeMultiplierUpgrade.new("Wiadro III", "", BuildingIds.Wiadro, 50000000000, 1.5, 25),
	MultiplicativeMultiplierUpgrade.new("Wiadro IV", "", BuildingIds.Wiadro, 200000, 1.5, 40),
	# Bongo
	MultiplicativeMultiplierUpgrade.new("Sitko na cybuch", "", BuildingIds.Bongo, 12500000000, 1.5, 5),
	MultiplicativeMultiplierUpgrade.new("Większy bowl", "", BuildingIds.Bongo, 25000000000, 1.5, 15),
	MultiplicativeMultiplierUpgrade.new("Dodatkowa filtracja", "", BuildingIds.Bongo, 10000000, 2, 30),
	MultiplicativeMultiplierUpgrade.new("Bongo IV", "", BuildingIds.Bongo, 20000000, 1.5, 75),
	# Joint
	MultiplicativeMultiplierUpgrade.new("Joint I", "", BuildingIds.Joint, 2000000000000, 2., 5),
	MultiplicativeMultiplierUpgrade.new("Joint II", "", BuildingIds.Joint, 5000000000000, 1.42, 10),
	MultiplicativeMultiplierUpgrade.new("Joint V", "", BuildingIds.Joint, 10000000000000, 1.5, 25), # This shit is broken as fuck
	MultiplicativeMultiplierUpgrade.new("Joint VI", "", BuildingIds.Joint, 5000000, 1.5, 30),
	MultiplicativeMultiplierUpgrade.new("Joint VII", "", BuildingIds.Joint, 5000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Joint VIII", "", BuildingIds.Joint, 5000000, 1.5, 75),
	MultiplicativeMultiplierUpgrade.new("Joint IX", "", BuildingIds.Joint, 5000000, 1.5, 100),
	# Wapo
	MultiplicativeMultiplierUpgrade.new("Pojemna bateria", "", BuildingIds.Wapo, 20000000000, 2, 5),
	MultiplicativeMultiplierUpgrade.new("Solidna konstrukcja", "", BuildingIds.Wapo, 50000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Szklany ustnik", "", BuildingIds.Wapo, 100000000000, 3, 20),
	MultiplicativeMultiplierUpgrade.new("Tytanowa komora grzewcza", "", BuildingIds.Wapo, 300000000000, 1.5, 30),
	MultiplicativeMultiplierUpgrade.new("Bubbler", "", BuildingIds.Wapo, 3000000000000, 2,100),
	# Dab
	MultiplicativeMultiplierUpgrade.new("Dab pen I", "", BuildingIds.Dab, 42000000000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Dab pen II", "", BuildingIds.Dab, 420000000000000000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Dab pen III", "", BuildingIds.Dab, 4200000000000000000, 1.5, 20),
	MultiplicativeMultiplierUpgrade.new("Dab pen IV", "", BuildingIds.Dab, 4200000000000000000, 1.25, 30),
	MultiplicativeMultiplierUpgrade.new("Dab pen V", "", BuildingIds.Dab, 4200000000000000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Dab pen VI", "", BuildingIds.Dab, 4200000000000000000, 1.333, 75),
	MultiplicativeMultiplierUpgrade.new("Dab pen VII", "", BuildingIds.Dab, 4200000000000000000, 1.25, 115),
	# Wulkan
	MultiplicativeMultiplierUpgrade.new("Wulkan I", "", BuildingIds.Wulkan, 42000000000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Wulkan II", "", BuildingIds.Wulkan, 420000000000000000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Wulkan III", "", BuildingIds.Wulkan, 4200000000000000000, 1.5, 20),
	MultiplicativeMultiplierUpgrade.new("Wulkan IV", "", BuildingIds.Wulkan, 4200000000000000000, 1.25, 30),
	MultiplicativeMultiplierUpgrade.new("Wulkan V", "", BuildingIds.Wulkan, 4200000000000000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Wulkan VI", "", BuildingIds.Wulkan, 4200000000000000000, 1.333, 75),
	MultiplicativeMultiplierUpgrade.new("Wulkan VII", "", BuildingIds.Wulkan, 4200000000000000000, 1.25, 115),
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
	# MapUpgrade.new("Przedmostki", "", 500, 0.5, "przedMostki.jpg"),
	MapUpgrade.new("Piwnica", "Ktoś nie zamknął drzwi w klatce, więc korzystaj", 0, 0, "piwnica.jpg"),
	MapUpgrade.new("DRB Górka", "Spot w krzakach", 10000, 0.4, "drbgorka.jpg"),
	MapUpgrade.new("Altana", "Altanka przy placu zabaw często odwiedzana w weekendy przez lokalnych chlejusów", 20000, 1, "altana.jpg"),
	MapUpgrade.new("Mostki", "Znana i sprawdzona melina względnie daleko od cywilizacji", 150000, 1, "mostki.jpg"),
	MapUpgrade.new("Diamentowy Las", "Mostki cz.2", 300000, 0.5, "Diamentowylas.jpg"),
	# MapUpgrade.new("Staromieście", "", 10000, 0.2, "staromiescie.jpg"),
	MapUpgrade.new("Spiżarnia", "Upizgany siedzisz w spiżarni", 25000000000, 0.3, "spizarnia.jpg"),
	MapUpgrade.new("Piekło", "Cmentarz zgonów", 2000000000000, 0.5, "piejlo.jpg"),
	MapUpgrade.new("Parapet", "Puste mieszkanie do hash-komory", 60000000000000, 0.5, "parapet.jpg"),
	MapUpgrade.new("Taras u Wolana", "...", 4180000000000000, 0.6, "wolan.jpg"),
	MapUpgrade.new("Dom Pompki", "...", 41900000000000000, 0.6, "lilpump.jpg"),
	MapUpgrade.new("Speluna", "...", 420000000000000000, 0.7, "speluna.jpg"),
]

# wynajmuje ogrodki dzialkowe i sadze tam skuna
# splacam pozyczke kruwaaaaaa

func upgrades_prestige():
	upgrades = [
	# SeriesPropertyUpgrade.new("chuj wie", "THC +%", "thcAddSeriesMult", 1.5, 1),

	# Zapalniczka
	AdditiveMultiplierUpgrade.new("Mechanizm zapalający", "Przycisk zapalniczki zrobiony z lżejszego plastiku dodaje wygody", BuildingIds.Zapalniczka, 5, 1, 5),
	AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 10, 1, 10),
	MultiplicativeMultiplierUpgrade.new("Zapasowy gaz", "Zapasy butli z płynem do zapalniczek rozwiązuje problem pustych zapalniczek", BuildingIds.Zapalniczka, 1500, 5, 25), # too much
		AdditiveMultiplierUpgrade.new("Przełączanie na +", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Zapalniczka, 10000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Zapalniczka - Mastery", "a chuj nie mastery", BuildingIds.Zapalniczka, 1000000000, 4.2, 75),
	MultiplicativeMultiplierUpgrade.new("Zapalniczka - Mastery", "", BuildingIds.Zapalniczka, 1500, 2.5, 75),
	# Jabłko
	MultiplicativeMultiplierUpgrade.new("Precyzyjne cięcie I", "", BuildingIds.Jablko, 300, 1.5, 5),
	MultiplicativeMultiplierUpgrade.new("Precyzyjne cięcie II", "", BuildingIds.Jablko, 2000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Jablko III", "tu jakies sick ulepszenie powinno byc bo powoduje ze jablko jest lepsze niz lufa i zapalara", BuildingIds.Jablko, 6000, 3, 20),
	MultiplicativeMultiplierUpgrade.new("Jablko III", "tu jakies sick ulepszenie powinno byc bo powoduje ze jablko jest lepsze niz lufa i zapalara", BuildingIds.Jablko, 10000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Jablko - Mastery", "Przełączenie zaworu pozwala na podawanie większej ilości gazu", BuildingIds.Jablko, 1000000000, 4.2, 75),
	# Lufka
	AdditiveMultiplierUpgrade.new("Lufka I", "", BuildingIds.Lufka, 10000, 0.4, 5),
	# AdditiveMultiplierUpgrade.new("Lufka II", "", BuildingIds.Lufka, 75000, 0.4, 10), # I don't think this one is necesssary
	MultiplicativeMultiplierUpgrade.new("Lufka III", "", BuildingIds.Lufka, 200000, 1.4, 15),
	Upgrade.new("Kontakty I", "Odblokowywuje samary z tematem z efektami ubocznymi po spaleniu", 100000, UnlockUpgsIDs.Samara),
	MultiplicativeMultiplierUpgrade.new("Lufka IV", "", BuildingIds.Lufka, 3500000, 5, 30),
	AdditiveMultiplierUpgrade.new("Turbo dojebany upg do lufki", "", BuildingIds.Lufka, 50000000, 5, 50),
	# AdditiveMultiplierUpgrade.new("Lufka I", "", BuildingIds.Lufka, 2000, 2, 50),
	# Wodospad
	MultiplicativeMultiplierUpgrade.new("Wprawa", "Wprawa w wypalaniu otworu pomocna w wydajnym i wygodnym paleniu", BuildingIds.Butla, 1000000, 1.5, 5),
	MultiplicativeMultiplierUpgrade.new("Wodospad II", "", BuildingIds.Butla,  5000000, 1.5, 10),
	MultiplicativeMultiplierUpgrade.new("Wodospad III", "", BuildingIds.Butla, 30000000, 1.5, 25),
	MultiplicativeMultiplierUpgrade.new("Wodospad IV", "", BuildingIds.Butla,  100000000, 1.5, 30),
	# Wiadro
	MultiplicativeMultiplierUpgrade.new("Wiadro I", "", BuildingIds.Wiadro, 500000000, 1.75, 10),
	# MultiplicativeMultiplierUpgrade.new("Wiadro II", "", BuildingIds.Wiadro, 50000, 1,5, 15), to jest troche niepotrzebne
	MultiplicativeMultiplierUpgrade.new("Wiadro III", "", BuildingIds.Wiadro, 5000000000000, 1.5, 25),
	MultiplicativeMultiplierUpgrade.new("Wiadro IV", "", BuildingIds.Wiadro, 200000, 1.5, 40),
	# Bongo
	MultiplicativeMultiplierUpgrade.new("Bongo I", "", BuildingIds.Bongo, 5000000, 3, 7),
	MultiplicativeMultiplierUpgrade.new("Bongo II", "", BuildingIds.Bongo, 8000000, 1.5, 15),
	MultiplicativeMultiplierUpgrade.new("Bongo III", "", BuildingIds.Bongo, 10000000, 1.5, 30),
	MultiplicativeMultiplierUpgrade.new("Bongo IV", "", BuildingIds.Bongo, 20000000, 1.5, 75),
	# Joint
	MultiplicativeMultiplierUpgrade.new("Joint II", "", BuildingIds.Joint, 5000000, 2, 5),
	MultiplicativeMultiplierUpgrade.new("Joint III", "", BuildingIds.Joint, 5000000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Joint IV", "", BuildingIds.Joint, 5000000, 1.5, 20),
	MultiplicativeMultiplierUpgrade.new("Joint V", "", BuildingIds.Joint, 5000000, 1.5, 25), # This shit is broken as fuck
	MultiplicativeMultiplierUpgrade.new("Joint VI", "", BuildingIds.Joint, 5000000, 1.5, 30),
	MultiplicativeMultiplierUpgrade.new("Joint VII", "", BuildingIds.Joint, 5000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Joint VIII", "", BuildingIds.Joint, 5000000, 1.5, 75),
	MultiplicativeMultiplierUpgrade.new("Joint IX", "", BuildingIds.Joint, 5000000, 1.5, 100),
	# Wapo
	MultiplicativeMultiplierUpgrade.new("Pojemna bateria", "", BuildingIds.Wapo, 20000000000, 2, 5),
	MultiplicativeMultiplierUpgrade.new("Solidna konstrukcja", "", BuildingIds.Wapo, 50000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Szklany ustnik", "", BuildingIds.Wapo, 100000000000, 3, 20),
	MultiplicativeMultiplierUpgrade.new("Tytanowa komora grzewcza", "", BuildingIds.Wapo, 300000000000, 1.5, 30),
	MultiplicativeMultiplierUpgrade.new("Bubbler", "", BuildingIds.Wapo, 3000000000000, 2,100),
	# Dab
	MultiplicativeMultiplierUpgrade.new("Dab pen I", "", BuildingIds.Dab, 42000000000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Dab pen II", "", BuildingIds.Dab, 420000000000000000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Dab pen III", "", BuildingIds.Dab, 4200000000000000000, 1.5, 20),
	MultiplicativeMultiplierUpgrade.new("Dab pen IV", "", BuildingIds.Dab, 4200000000000000000, 1.25, 30),
	MultiplicativeMultiplierUpgrade.new("Dab pen V", "", BuildingIds.Dab, 4200000000000000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Dab pen VI", "", BuildingIds.Dab, 4200000000000000000, 1.333, 75),
	MultiplicativeMultiplierUpgrade.new("Dab pen VII", "", BuildingIds.Dab, 4200000000000000000, 1.25, 115),
	# Wulkan
	MultiplicativeMultiplierUpgrade.new("Wulkan I", "", BuildingIds.Wulkan, 42000000000000000, 2, 10),
	MultiplicativeMultiplierUpgrade.new("Wulkan II", "", BuildingIds.Wulkan, 420000000000000000, 2, 15),
	MultiplicativeMultiplierUpgrade.new("Wulkan III", "", BuildingIds.Wulkan, 4200000000000000000, 1.5, 20),
	MultiplicativeMultiplierUpgrade.new("Wulkan IV", "", BuildingIds.Wulkan, 4200000000000000000, 1.25, 30),
	MultiplicativeMultiplierUpgrade.new("Wulkan V", "", BuildingIds.Wulkan, 4200000000000000000, 1.5, 50),
	MultiplicativeMultiplierUpgrade.new("Wulkan VI", "", BuildingIds.Wulkan, 4200000000000000000, 1.333, 75),
	MultiplicativeMultiplierUpgrade.new("Wulkan VII", "", BuildingIds.Wulkan, 4200000000000000000, 1.25, 115),
]
	mapUpgrades = [
	# MapUpgrade.new("Przedmostki", "", 500, 0.5, "przedMostki.jpg"),
	MapUpgrade.new("Altana", "Lokalna altana przy placu zabaw", 2500, 0.2, "altana.jpg"),
	MapUpgrade.new("DRB Górka", "Spot w krzakach", 20000, 0.2, "drbgorka.jpg"),
	MapUpgrade.new("Mostki", "Znana każdemu ćpunowi melina na osiedlu", 50000, 0.3, "mostki.jpg"), # Too cheap 7.5mg/s
	MapUpgrade.new("Diamentowy Las", "Głębsza część legendarnej meliny", 250000, 0.3, "Diamentowylas.jpg"),
	# MapUpgrade.new("Staromieście", "", 10000, 0.2, "staromiescie.jpg"),
	MapUpgrade.new("Spiżarnia", "Upizgany siedzisz w spiżarni", 200000000000, 0.3, "spizarnia.jpg"),
	MapUpgrade.new("Piekło", "Cmentarz zgonów", 2000000000000, 0.5, "piejlo.jpg"),
	MapUpgrade.new("Parapet", "Puste mieszkanie do hash-komory", 60000000000000, 0.5, "parapet.jpg"),
	MapUpgrade.new("Taras u Wolana", "...", 4180000000000000, 0.6, "wolan.jpg"),
	MapUpgrade.new("Dom Pompki", "...", 41900000000000000, 0.6, "lilpump.jpg"),
	MapUpgrade.new("Speluna", "...", 420000000000000000, 0.7, "speluna.jpg"),
	]

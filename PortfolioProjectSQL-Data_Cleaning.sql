/*
Cleaning Data inSQL queries
*/

--USE [PortFolio Project]

Select * from Nashvilehousing

Select SaleDate, CONVERT(date,SaleDate)
From Nashvilehousing

Update Nashvilehousing
SET SaleDate= CONVERT(date,SaleDate)

--In above query SaleDate is not updating.
--Adding a column in table as Date format.

Select SaleDateConverted, CONVERT(date,SaleDate)
From Nashvilehousing

Alter Table Nashvilehousing
Add SaleDateConverted Date

Update Nashvilehousing
SET SaleDateConverted = CONVERT(date,SaleDate)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate property Address

Select *
From Nashvilehousing
--where PropertyAddress is null
order by ParcelID

--the result table is having duplicate data repeats twice.So, we need to paste the same address same for duplicate where it is null

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashvilehousing a
	Join Nashvilehousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--Updating the table with above query

update a --nashvilehousing
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashvilehousing a
	Join Nashvilehousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Breakng out Address into Adress,city,state columns

select PropertyAddress
from Nashvilehousing


Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress)) as City
from Nashvilehousing



Alter Table Nashvilehousing
Add PropertySplitAddress nvarchar(255);

Update Nashvilehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


Alter Table Nashvilehousing
Add PropertySplitCity nvarchar(255)

Update Nashvilehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress))

Select PropertySplitCity,PropertySplitAddress
from Nashvilehousing

--doing same for owner address

Select OwnerAddress
from Nashvilehousing

Select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from Nashvilehousing


Alter Table Nashvilehousing
Add OwnerSplitAddress nvarchar(255);

Update Nashvilehousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


Alter Table Nashvilehousing
Add OwnerSplitCity nvarchar(255)

Update Nashvilehousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)


Alter Table Nashvilehousing
Add OwnerSplitState nvarchar(255)

Update Nashvilehousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)


select OwnerSplitAddress,OwnerSplitcity,OwnerSplitState
from Nashvilehousing


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from Nashvilehousing
Group by SoldAsVacant
order by 2 


Select SoldAsVacant
, Case  when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' Then 'No'
 else SoldAsVacant
 END
from Nashvilehousing


Update Nashvilehousing
SET SoldAsVacant =  Case  when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' Then 'No'
 else SoldAsVacant
 END

 Select Distinct(SoldAsVacant), count(SoldAsVacant)
from Nashvilehousing
Group by SoldAsVacant
order by 2 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


With RowNumCTE AS(
    Select *,
	ROW_NUMBER() Over (
	Partition BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
				 UniqueID)	row_num
From Nashvilehousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

--Delete rows
--The below query need to execute right after CTE query same for select query

Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From Nashvilehousing


ALTER TABLE Nashvilehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------











select * from PortfolioProject..NashvilleHousing

-- Making the date format usable and clear
select SaleDate,CONVERT(Date,SaleDate)
from PortfolioProject..NashvilleHousing


Alter Table PortfolioProject.. NashvilleHousing
Add SaleDateConverted Date;

update PortfolioProject..NashvilleHousing
Set SaleDateConverted=CONVERT(Date,SaleDate)


select SaleDateConverted from PortfolioProject..NashvilleHousing;


-- Poppulationg Property address data
select *
from PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress ,b.ParcelID,b.PropertyAddress,IsNull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress=IsNull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Property address into different columns and make it usable
select PropertyAddress
from PortfolioProject..NashvilleHousing
--order by ParcelID

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing



Alter Table PortfolioProject.. NashvilleHousing
Add PropertySpliCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
Set PropertySpliCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Alter Table PortfolioProject.. NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
Set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

select * from PortfolioProject..NashvilleHousing

-- Using a different approach to split the Owneraddress and make it usable
select OwnerAddress from PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)

from PortfolioProject..NashvilleHousing

Alter Table PortfolioProject.. NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table PortfolioProject.. NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
update PortfolioProject..NashvilleHousing
Set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table PortfolioProject.. NashvilleHousing
Add OwnerSplitState Nvarchar(255);
update PortfolioProject..NashvilleHousing
Set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from PortfolioProject..NashvilleHousing

-- Changing Y and N to yes and no in sold as vacent column
select Distinct (SoldAsVacant),COUNT(SoldasVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

Update PortfolioProject..NashvilleHousing
set SoldAsVacant=
CASE when SoldAsVacant ='Y' THEN 'Yes'
      when SoldAsVacant ='N' THEN 'No'
	  ELSE SoldAsVacant
	  END 
Select SOldAsVacant from PortfolioProject..NashvilleHousing

-- Removing Duplicates and cleaning all tables
WITH RowNumCTE AS(
Select *,
   ROW_NUMBER() OVER(
   PARTITION BY Parcelid,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID) row_num
 from PortfolioProject..NashvilleHousing)
 --order by ParcelID)
Delete
from RowNumCTE
where row_num>1

-- Getting id of unused columns
Alter Table PortfolioProject..NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress

Select * 
From PortfolioProject..NashvilleHousing
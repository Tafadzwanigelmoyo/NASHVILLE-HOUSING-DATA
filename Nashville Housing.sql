select *
from [Nashville Housing]

---------------------------------------------------------------------------------------------------------------------------------------------------


--Standardize Sale Date Format

select SaleDateConverted, CONVERT(date, saledate)
from [Nashville Housing]

Update [Nashville Housing]
set SaleDate = CONVERT(date, saledate)

--Adding a Column in our table
Alter Table [Nashville Housing]
Add SaleDateConverted Date;

--Update the new column with the new format
Update [Nashville Housing]
set SaleDateConverted = CONVERT(date, saledate)

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data
Select *
from [Nashville Housing]
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
Join [Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing] a
Join [Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking the Address into Individual Columns ( Address, City, State)

Select 
SUBSTRING(propertyAddress,1,charindex(',', PropertyAddress) -1)as Address,
SUBSTRING(propertyAddress,charindex(',', PropertyAddress) +1, len(PropertyAddress)) as City
from [Nashville Housing]

--Adding a Column in our table
Alter Table [Nashville Housing]
Add PropertySplitAddress varchar(200);

--Update the new column with the new format
Update [Nashville Housing]
set PropertySplitAddress = SUBSTRING(propertyAddress,1,charindex(',', PropertyAddress) -1) 


Alter Table [Nashville Housing]
Add PropertyAddressCity varchar(200);

Update [Nashville Housing]
set PropertyAddressCity = SUBSTRING(propertyAddress,charindex(',', PropertyAddress) +1, len(PropertyAddress))



select 
PARSENAME(Replace(ownerAddress, ',','.') ,3),
PARSENAME(Replace(ownerAddress, ',','.') ,2),
PARSENAME(Replace(ownerAddress, ',','.') ,1)
from [Nashville Housing]

--Adding a Column in our table
Alter Table [Nashville Housing]
Add OwnerSplitAddress varchar(200);

--Update the new column with the new format
Update [Nashville Housing]
set OwnerSplitAddress = PARSENAME(Replace(ownerAddress, ',','.') ,3) 


Alter Table [Nashville Housing]
Add OwnerAddressCity varchar(200);

Update [Nashville Housing]
set OwnerAddressCity = PARSENAME(Replace(ownerAddress, ',','.') ,2)

Alter Table [Nashville Housing]
Add OwnerAddressState varchar(200);

Update [Nashville Housing]
set OwnerAddressState = PARSENAME(Replace(ownerAddress, ',','.') ,1)


--------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in the SoldAsVacant Column


select distinct(SoldAsVacant), COUNT(soldasvacant)
from [Nashville Housing]
group by SoldAsVacant

select SoldAsVacant
, Case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END
from [Nashville Housing]

Update [Nashville Housing]
set SoldAsVacant = Case when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END


-----------------------------------------------------------------------------------------------------------------------------------------------
 
 --Remove Duplicates

 with RowNumCTE As(
 select *,
	 ROW_NUMBER() over( 
	 partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order By
						UniqueID
						) row_num
 from [Nashville Housing]

 )
 select *
 from RowNumCTE
 where row_num > 1
 order by PropertyAddress


 -------------------------------------------------------------------------------------------------------------------------------------------------

 --Delect Unused Columns

 Alter Table [Nashville Housing]
 Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

  Alter Table [Nashville Housing]
 Drop column SaleDate

 Select *
 FROM [Nashville Housing]
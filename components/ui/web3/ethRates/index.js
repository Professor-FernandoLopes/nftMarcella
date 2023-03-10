
import { useEthPrice, COURSE_PRICE } from "@components/hooks/useEthPrice"
import { Loader } from "@components/ui/common"
import Image from "next/image"

export default function EthRates() {
const { eth } = useEthPrice()

return (
<div className="flex flex-col xs:flex-row text-center">
<div className="p-6 border drop-shadow rounded-md mr-2">
<div className="flex items-center justify-center">
{ eth.data ? 
<>
<Image
layout="fixed"
height="35"
width="35"
src="/polygon.webp"
/>
<span className="text-xl font-bold text-white">
= {eth.data}$
</span>
</> :
<div className="w-full flex justify-center">
<Loader size="md" />
</div>
}
</div>
<p className="text-lg text-blue2"> Preço Matic</p>
</div>
<div className="p-6 border drop-shadow rounded-md">
<div className="flex items-center justify-center">
{ eth.data ?
<>
<span className="text-xl font-bold text-white">
{/*{eth.perItem}*/}
</span>
<Image
layout="fixed"
height="35"
width="35"
src="/polygon.webp"
/>
<span className="text-xl font-bold text-white">
= {COURSE_PRICE}
</span>
</> :
<div className="w-full flex justify-center">
<Loader size="md" />
</div>
}
</div>
<p className="text-lg text-blue2">Preço fração NFT </p>
</div>
</div>
)
}



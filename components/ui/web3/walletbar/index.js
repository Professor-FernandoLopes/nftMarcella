
import { useWalletInfo } from "@components/hooks/web3"
import { useWeb3 } from "@components/providers"
import { Button } from "@components/ui/common"


export default function WalletBar() {
const { requireInstall } = useWeb3()
const { account, network } = useWalletInfo()

return (
<section className="text-white text-gray-500 hover:text-gray-900 rounded-lg">
<div className="p-8">


<div className="flex justify-between items-center">
<div className="sm:flex sm:justify-center lg:justify-start">

</div>
<div>
{ network.hasInitialResponse && !network.isSupported &&
<div className=" p-4 rounded-lg">
<div>Você está na rede errada</div>
<div>
Connect à {` `}
<strong className="text-2xl">
{network.target}
</strong>
</div>
</div>
}
{ requireInstall &&
<div className="bg-yellow-500 p-4 rounded-lg">
Para acessar a Web3 instale Metamask.
</div>
}
{ network.data &&
<div>
<span>Você está na </span>
<strong className="text-2xl">{network.data}</strong>
</div>
}
</div>
</div>
</div>
</section>
)
}

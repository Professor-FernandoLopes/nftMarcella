import { useAccount, useOwnedCourse } from "@components/hooks/web3";
import { useWeb3 } from "@components/providers";
import { Message, Modal } from "@components/ui/common";
import {
CourseHero,
Curriculum,
Keypoints
} from "@components/ui/course";
import { BaseLayout } from "@components/ui/layout";
import { getAllCourses } from "@content/courses/empresas";

export default function Course({course}) {
const { isLoading } = useWeb3()
const { account } = useAccount()
const { ownedCourse } = useOwnedCourse(course, account.data)
const courseState = ownedCourse.data?.state
// const courseState = "deactivated"

const isLocked =
!courseState ||
courseState === "purchased" ||
courseState === "deactivated"
// CourseHero recebe imagem como props
return (
<>
<div className="py-0">
<CourseHero
hasOwner={!!ownedCourse.data}
title={course.title}
description={course.description}
image= {course.coverImage}
/>
</div>
<Keypoints
points={course.wsl}
/>
{ courseState &&
<div className="max-w-5xl mx-auto">
{ courseState === "purchased" &&
<Message type="warning">
A compra está pendente de ativação, para verificação do cumprimento dos termos do NFT CONTRACT
<i className="block font-normal">Em caso de dúvidas, entre em contato com a DataCurrency</i>
</Message>
}
{ courseState === "activated" &&
<Message type="success">
Pagamento confirmado.
</Message>
}
{ courseState === "deactivated" &&
<Message type="danger">
A compra foi recusada, devido ao não cumprimento dos termos do NFT CONTRACT.

<i className="block font-normal">Please contact datacurrency.uk</i>
</Message>
}
</div>
}
<Curriculum
isLoading={isLoading}
locked={isLocked}
courseState={courseState}
/>
<Modal />
</>
)
}

export function getStaticPaths() {
const { data } = getAllCourses()

return {
paths: data.map(c => ({
params: {
slug: c.slug
}
})),
fallback: false
}
}


export function getStaticProps({params}) {
const { data } = getAllCourses()
const course = data.filter(c => c.slug === params.slug)[0]

return {
props: {
course
}
}
}

Course.Layout = BaseLayout

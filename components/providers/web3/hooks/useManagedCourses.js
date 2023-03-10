

// muito importante este hook
import { normalizeOwnedCourse } from "@utils/normalize"
import useSWR from "swr"

export const handler = (web3, contract) => account => {

const swrRes = useSWR(() =>
(web3 &&
contract &&
account.data && account.isAdmin ) ? `web3/managedCourses/${account.data}` : null,
async () => {
// Aqui eu vou ter a informação de todos os cursos normalized
const courses = []

/* Em course count temos o total de cursos vendidos */
const courseCount = await contract.methods.getCourseCount().call()

// aqui está a mágica. Diminui um porque começa em zero
for (let i = Number(courseCount) - 1; i >= 0; i--) {

// Aqui está o course hash
const courseHash = await contract.methods.getCourseHashAtIndex(i).call()

// Aqui está a informação de cada curso
const course = await contract.methods.getCourseByHash(courseHash).call()

if (course) {
const normalized = normalizeOwnedCourse(web3)({ hash: courseHash }, course)

// Aqui eu insiro todos os cursos normalized
courses.push(normalized)
}


}

// aqui tenho a informação de todos os cursos normalized
return courses
}
)

return swrRes
}
